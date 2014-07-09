//std
#include <cstdlib>
#include <iostream>
#include <fstream>
#include <map>

//boost
#include <boost\algorithm\string.hpp>
#include <boost\filesystem.hpp>
#include <boost\lexical_cast.hpp>

int main(int argc, char** argv)
{
    using namespace boost::filesystem;

    std::string mod_name;

    for (auto i = 0; i < argc; ++i)
    {
        if (boost::algorithm::starts_with(argv[i], "-mod="))
        {
            std::vector<std::string> tokens;
            boost::algorithm::split(tokens, argv[i], boost::is_any_of("="), boost::algorithm::token_compress_on);

            if (tokens.size() > 1)
            {
                mod_name = tokens[1];
            }
        }
    }

    if (mod_name.empty())
    {
        std::cerr << "ERROR: mod not specified (use -mod=<mod_name>)" << std::endl;

        return 1;
    }

    size_t size = 0;
    char rodir[_MAX_PATH] = { '\0' };

    getenv_s(&size, rodir, "RODIR");

    if (rodir == nullptr)
    {
        std::cerr << "ERROR: Environment variable 'RODIR' is not set." << std::endl;

        return 1;
    }

    path red_orchestra_root_directory = rodir;

    if (!is_directory(red_orchestra_root_directory))
    {
        std::cerr << "ERROR: 'RODIR' (" << red_orchestra_root_directory << ") is not a directory." << std::endl;

        return 1;
    }

    path red_orchestra_system_directory = red_orchestra_root_directory;
    red_orchestra_system_directory += "\\System";

    auto mod_directory = red_orchestra_root_directory;
    mod_directory += "\\" + mod_name;

    if (!exists(mod_directory))
    {
        std::cerr << "ERROR: Mod directory (" << mod_directory << ") does not exist." << std::endl;

        return 1;
    }

    auto mod_system_directory = mod_directory;
    mod_system_directory += "\\System";

    if (!exists(mod_system_directory))
    {
        std::cerr << "ERROR: Mod System directory (" << mod_system_directory << ") does not exist." << std::endl;

        return 1;
    }

    auto mod_ini_path = mod_system_directory;
    mod_ini_path += "\\" + mod_name + ".ini";

    if (!exists(mod_ini_path))
    {
        std::cerr << "ERROR: mod .ini (" << mod_name << ") does not exist.";

        return 1;
    }

    std::ifstream mod_ini_stream;
    mod_ini_stream.open(mod_ini_path.c_str());

    std::vector<std::string> edit_packages;

    while (mod_ini_stream.good())
    {
        std::string line;

        std::getline(mod_ini_stream, line);

        boost::algorithm::trim(line);

        if (boost::starts_with(line, "EditPackages"))
        {
            std::vector<std::string> tokens;
            boost::algorithm::split(tokens, line, boost::is_any_of("="), boost::algorithm::token_compress_on);

            if (tokens.size() != 2)
            {
                std::cerr << "ERROR: invalid 'EditPackages' entry in .ini.";

                return 1;
            }

            //if (boost::algorithm::starts_with(tokens[1], "DH"))
            {
                edit_packages.push_back(tokens[1]);
            }
        }
    }

    std::vector<std::string> packages_to_compile;

    std::map<boost::filesystem::path, time_t> package_write_times;

    for (auto& edit_package : edit_packages)
    {
        auto src_dir = red_orchestra_root_directory;
        src_dir += "\\" + edit_package + "\\Classes";

        if (!is_directory(src_dir))
        {
            std::cerr << "WARNING: no such source directory (\"" << src_dir << "\").";

            continue;
        }

        path package_path = mod_system_directory;
        package_path += "\\" + edit_package + ".u";

        if (exists(package_path))
        {
            for (auto itr = directory_iterator(src_dir); itr != directory_iterator(); ++itr)
            {
                if (last_write_time(itr->path()) > last_write_time(package_path))
                {
                    packages_to_compile.push_back(edit_package);

                    break;
                }
            }
        }
        else
        {
            packages_to_compile.push_back(edit_package);
        }
    }

    if (packages_to_compile.empty())
    {
        std::cout << "no packages to compile" << std::endl;

        return 1;
    }

    for (auto& package : packages_to_compile)
    {
        path package_path = mod_system_directory;
        package_path += "\\" + package;
        package_path.replace_extension("u");

        if (exists(package_path))
        {
            boost::system::error_code error_code;

            remove(package_path, error_code);

            if (error_code)
            {
                std::cerr << "ERROR: unable to delete package \"" << package_path.filename() << "\" (is it open in another process?)" << std::endl;

                system("PAUSE");

                return 1;
            }
        }
    }

    std::string cmd = "cd %RODIR%\\System && ucc make -mod=" + mod_name;

    auto stream = _popen(cmd.c_str(), "r");
    char buffer[255];

    while (fgets(buffer, sizeof(buffer), stream) != NULL)
    {
        std::string line = buffer;

        std::cout << buffer;
    }

    //copy compiled .u files to mod system directory and delete them
    for (auto itr = directory_iterator(red_orchestra_system_directory); itr != directory_iterator(); ++itr)
    {
        for (auto& package : packages_to_compile)
        {
            if (itr->path().filename() == package + ".u")
            {
                boost::system::error_code error_code;

                copy(itr->path(), mod_system_directory.string() + "\\" + itr->path().filename().string(), error_code);

                std::string path = itr->path().string();

                remove(itr->path());
            }
        }
    }
}
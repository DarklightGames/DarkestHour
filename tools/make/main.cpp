//std
#include <cstdlib>
#include <iostream>
#include <fstream>
#include <map>

//boost
#include <boost\algorithm\string.hpp>
#include <boost\filesystem.hpp>
#include <boost\lexical_cast.hpp>

#define EXIT(RESULT)\
    if(!should_close_on_finish)\
    {\
        system("PAUSE");\
    }\
    \
    return RESULT;

int main(int argc, char** argv)
{
    using namespace boost::filesystem;

    std::string mod_name;
    bool is_silent = false;
    bool should_close_on_finish = false;

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
        else if (_strcmpi(argv[i], "--close") == 0)
        {
            should_close_on_finish = true;
        }
    }

    if (mod_name.empty())
    {
        std::cerr << "ERROR: mod not specified (use -mod=<mod_name>)" << std::endl;

        EXIT(1);
    }

    size_t size = 0;
    char rodir[_MAX_PATH] = { '\0' };

    getenv_s(&size, rodir, "RODIR");

    if (rodir == nullptr)
    {
        std::cerr << "ERROR: Environment variable RODIR is not set." << std::endl;

        EXIT(1);
    }

    path root_directory = rodir;

    if (!is_directory(root_directory))
    {
        std::cerr << "ERROR: RODIR (" << root_directory << ") is not a directory." << std::endl;

        EXIT(1);
    }

    path root_system_directory = root_directory;
    root_system_directory += "\\System";

    auto mod_directory = root_directory;
    mod_directory += "\\" + mod_name;

    if (!exists(mod_directory))
    {
        std::cerr << "ERROR: Mod directory (" << mod_directory << ") does not exist." << std::endl;

        EXIT(1);
    }

    auto mod_system_directory = mod_directory;
    mod_system_directory += "\\System";

    if (!exists(mod_system_directory))
    {
        std::cerr << "ERROR: Mod System directory (" << mod_system_directory << ") does not exist." << std::endl;

        EXIT(1);
    }

    auto mod_ini_path = mod_system_directory;
    mod_ini_path += "\\" + mod_name + ".ini";

    if (!exists(mod_ini_path))
    {
        std::cerr << "ERROR: mod .ini (" << mod_name << ") does not exist.";

        EXIT(1);
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

                EXIT(1);
            }

            edit_packages.push_back(tokens[1]);
        }
    }

    std::vector<std::string> packages_to_compile;

	for (size_t i = 0; i < edit_packages.size(); ++i)
    {
		const auto& edit_package = edit_packages[i];

        auto src_dir = root_directory;
        src_dir += "\\" + edit_package + "\\Classes";

        if (!is_directory(src_dir))
        {
            std::cerr << "WARNING: no such source directory (\"" << src_dir << "\")." << std::endl;

            continue;
        }

        //build path for package in mod system directory
        path mod_package_path = mod_system_directory;
        mod_package_path += "\\" + edit_package + ".u";

        //build path for package in root 
        path root_package_path = root_system_directory;
        root_package_path += "\\" + edit_package + ".u";

        if (exists(mod_package_path))
        {
            for (auto itr = directory_iterator(src_dir); itr != directory_iterator(); ++itr)
            {
                if (last_write_time(itr->path()) > last_write_time(mod_package_path))
                {
                    packages_to_compile.push_back(edit_package);

                    break;
                }
            }
        }
        else if (!exists(root_package_path))
        {
            packages_to_compile.push_back(edit_package);
        }
    }

    if (packages_to_compile.empty())
    {
        std::cout << "no packages to compile" << std::endl;

        EXIT(1);
    }
	
	for (size_t i = 0; i < packages_to_compile.size(); ++i)
    {
		const auto& package = packages_to_compile[i];

        std::cout << "\"" << package << "\" marked for building." << std::endl;

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

                EXIT(1);
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
    for (auto itr = directory_iterator(root_system_directory); itr != directory_iterator(); ++itr)
    {
		for (size_t i = 0; i < packages_to_compile.size(); ++i)
		{
			const auto& package = packages_to_compile[i];

            if (itr->path().filename() == package + ".u")
            {
                boost::system::error_code error_code;

                copy(itr->path(), mod_system_directory.string() + "\\" + itr->path().filename().string(), error_code);

                std::string path = itr->path().string();

                remove(itr->path());
            }
        }
    }

    EXIT(0);
}
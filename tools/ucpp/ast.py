from yacc import parser
from lex import lexer
import re


class ucppparser():
    def __init__(self):
        self.ast = None
        self.generic_types = []
        self.template_parameters = []
        self.template_arguments = []
        self.classname = ''
        self.indentation = 0

    def compile(self, s):
        lexer.lineno = 1
        return parser.parse(s, debug=False)

    def render(self, ast, template_arguments=[]):
        self.indentation = 0
        self.template_arguments = template_arguments
        self.classname = '_'.join([ast[1][0][1][1]] + self.template_arguments)
        return render(ast)


    def indent(self):
        return '    ' * self.indentation


ucpp = ucppparser()


def r_directive(p):
    return p[1]


def r_within(p):
    return 'within(' + render(p[1]) + ')'


def r_constructor(p):
    # create the 'return self' as the last line
    p[2][2][1].append(('codeline', ('return_statement', ('identifier', 'self'))))
    return 'function %s __ctor__(%s)\n%s' % (ucpp.classname, render(p[1]), render(p[2]))


def r_function_modifiers(p):
    return ' '.join(render(q) for q in p[1])


# def r_elif_statements(p):
#     return render(p[1])


def r_elif_statement(p):
    s = ucpp.indent() + 'else if (' + render(p[1]) + ')\n'
    s += ucpp.indent() + '{\n'
    ucpp.indentation += 1
    s += render(p[2])
    ucpp.indentation -= 1
    s += '\n' + ucpp.indent() + '}'
    return s


def r_else_statement(p):
    s = ucpp.indent() + 'else\n'
    s += ucpp.indent() + '{\n'
    ucpp.indentation += 1
    s += render(p[1])
    ucpp.indentation -= 1
    s += '\n' + ucpp.indent() + '}'
    return s


def r_if_statement(p):
    s = ucpp.indent() + 'if (' + render(p[1]) + ')\n'
    s += ucpp.indent() + '{\n'
    ucpp.indentation += 1
    s += render(p[2])
    ucpp.indentation -= 1
    s += '\n' + ucpp.indent() + '}'
    t = '\n'.join(map(lambda x: render(x), p[3]))
    u = render(p[4])
    return '\n'.join(filter(lambda x: x != '', [s, t, u]))



def r_pre_unary_operation(p):
    return '{}{}'.format(render(p[1]), render(p[2]))


def r_post_unary_operation(p):
    return '{}{}'.format(render(p[1]), render(p[2]))


def r_unary_operation(p):
    return '{}{}'.format(render(p[1]), render(p[2]))


def r_string_parameterized(p):
    s = '"' + re.sub('{(.+?)}', lambda x: '" $ %s $ "' % x.groups()[0], p[1]) + '"'
    return s


def r_for_statement(p):
    s = ucpp.indent()  + 'for (' + '; '.join(map(lambda x: render(x), p[1:4])) + ')\n'
    s += ucpp.indent() + '{\n'
    ucpp.indentation += 1
    s += render(p[4])
    ucpp.indentation -= 1
    s += '\n' + ucpp.indent() + '}'
    return s


def r_binary_operation(p):
    return ' '.join([render(p[2]), render(p[1]), render(p[3])])


def r_replication_block(p):
    return 'replication\n{\n' + '\n\n'.join(map(lambda x: render(x), p[1])) + '\n}'


def r_replication_statement(p):
    return p[1] + ' if (' + render(p[2]) + ')\n' + render(p[3]) + ';'

def r_return_statement(p):
    if p[1] is None:
        return 'return'
    return 'return %s' % render(p[1])


def r_number(p):
    return str(p[1])


def r_argument_list(p):
    return ', '.join(render(q) for q in p[1])


def r_call(p):
    return '{}({})'.format(render(p[1]), render(p[2]))


def r_attribute(p):
    return '{}.{}'.format(render(p[1]), render(p[2]))


def r_assignment_statement(p):
    return '{} {} {}'.format(render(p[2]), p[1], render(p[3]))


def r_subscription(p):
    return '{}[{}]'.format(render(p[1]), render(p[2]))


def r_statements(p):
    if p[1] is None:
        return ''
    return '\n'.join(render(q) for q in p[1])


def r_function_body(p):
    s = '\n\n'.join([render(p[1]), render(p[2])]).strip('\n')
    s = '{\n%s\n}' % s
    return s


def r_local_declaration(p):
    return ucpp.indent() + ('local %s %s;' % (render(p[1]), render(p[2])))


def r_local_declarations(p):
    if p[1] is None:
        return ''
    return '\n'.join(render(q) for q in p[1])


def r_var_name(p):
    if p[2] is None:
        return render(p[1])
    else:
        return '%s[%s]' % (render(p[1]), render(p[2]))


def r_var_modifiers(p):
    if p[1] is None:
        return ''
    return ' '.join(map(lambda x: render(x), p[1]))


def r_array(p):
    return 'array<{}>'.format(render(p[1]))


def r_arraycount(p):
    return 'arraycount(%s)' % render(p[1])


def r_var_name_list(p):
    return ', '.join(render(q) for q in p[1])


def r_var_declaration(p):
    return ' '.join(filter(lambda x: x != '', ['var' + render(p[1])] + list(render(x) for x in p[2:]))) + ';'


def r_paren_id(p):
    return '(' + render(p[1]) + ')'

def r_function_declaration(p):
    return '%s(%s)' % (' '.join(filter(None, [render(q) for q in (p[4], p[1], p[3], p[2])])), render(p[5]))


def r_function_definition(p):
    if p[2] is None:
        return '{};'.format(render(p[1]))
    else:
        s = render(p[1])
        ucpp.indentation += 1
        t = render(p[2])
        ucpp.indentation -= 1
        return '\n'.join([s, t])


def r_config(p):
    return p[0]


def r_function_argument(p):
    s = ' '.join(filter(lambda x: x != '', map(lambda y: render(y), p[1:4])))
    if p[4] is not None:
        s = '%s[%d]' % (s, p[4])
    return s


def r_function_argument_modifiers(p):
    return ' '.join(p[1])


def r_function_arguments(p):
    return ', '.join(render(q) for q in p[1])


def r_declarations(p):
    if p[1] is None:
        return ''
    return '\n\n'.join(render(q) for q in p[1])


def r_identifier_list(p):
    return ', '.join(render(q) for q in p[1])


def r_template(p):
    global ucpp
    ucpp.template_parameters = [render(q) for q in p[1][1]]
    return ''


def r_generic_type(p):
    global  ucpp
    return '{}_{}'.format(render(p[1]), '_'.join(render(q) for q in p[2]))


def r_type(p):
    return render(p[1])


def r_class_modifiers(p):
    ucpp.indentation += 1
    s = '\n'.join(ucpp.indent() + render(q) for q in p[1] if q)
    ucpp.indentation -= 1
    return s


def r_identifier(p):
    global ucpp
    s = render(p[1])
    # TODO: do a look-up for template parameters, in scope
    try:
        i = ucpp.template_parameters.index(s)
        print '*' * 100
        print ucpp.template_parameters
        return render(ucpp.template_arguments[i])
    except ValueError:
        return s


def r_goto(p):
    return 'Goto(' + render(p[1]) + ')'


def r_label(p):
    return p[1] + ':'


def r_defaultproperties(p):
    if p[1] is None:
        return ''
    s = 'defaultproperties\n{\n'
    ucpp.indentation += 1
    s +=  '\n'.join(ucpp.indent() + render(k) for k in p[1])
    ucpp.indentation -= 1
    s += '\n}'
    return s


def r_defaultproperties_assignment(p):
    return '%s=%s' % (render(p[1]), render(p[2]))


def r_defaultproperties_key(p):
    if p[2] is not None:
        return '%s(%s)' % (render(p[1]), p[2])
    else:
        return render(p[1])


def r_defaultproperties_array(p):
    return '(' + ','.join(map(lambda x: render(x), p[1])) + ')'


def r_defaultproperties_object(p):
    global ucpp
    s = 'Begin Object Class=%s Name=%s\n' % (render(p[1]), render(p[2]))
    ucpp.indentation += 1
    s += '\n'.join((ucpp.indent() + render(k)) for k in p[3])
    ucpp.indentation -= 1
    s += '\n' + ucpp.indent() + 'End Object'
    return s


def r_class_declaration(p):
    global ucpp
    # TODO: pretty sure classes can extend nothing!
    s = ' '.join(filter(lambda x: x != '', ['class', ucpp.classname, render(p[2])]))
    t = render(p[3])
    return '\n'.join(filter(lambda x: x != '', [s, t])) + ';'


def r_defaultproperties_object_arguments(p):
    return '(%s)' % ','.join(render(k) for k in p[1])


def r_struct_definition(p):
    return '%s;' % render(p[1])


def r_enum_values(p):
    global ucpp
    return ',\n'.join(map(lambda x: ucpp.indent() + x, p[1]))


def r_expression_parenthesized(p):
    return '(%s)' % render(p[1])


def r_enum_definition(p):
    return '%s;' % render(p[1])


def r_enum_declaration(p):
    s = 'enum ' + p[1] + '\n{\n'
    ucpp.indentation += 1
    s += render(p[2])
    ucpp.indentation -= 1
    s += '\n}'
    return s


def r_const_declaration(p):
    return 'const %s = %s;' % (render(p[1]), render(p[2]))


def r_class_type(p):
    return 'class<%s>' % render(p[1])


def r_struct_declaration(p):
    name, var_declarations = p[1], p[2]
    s = 'struct %s\n{\n%s\n}' % (render(name), render(var_declarations))
    return s


def r_struct_var_declarations(p):
    return '\n'.join(render(x) for x in p[1])


def r_struct_var_declaration(p):
    return 'var%s %s %s %s;' % tuple(map(lambda x: render(x), p[1:]))


def r_default(p):
    return 'default.%s' % render(p[1])


def r_default_case(p):
    s = ucpp.indent() + 'default:\n'
    ucpp.indentation += 1
    s += render(p[1])
    ucpp.indentation -= 1
    return s


def r_super_call(p):
    if p[1] is None:
        return 'super.%s' % render(p[2])
    else:
        return 'super%s.%s' % (render(p[1]), render(p[2]))


def r_reference(p):
    return render(p[1])


def r_foreach_statement(p):
    s = ucpp.indent() + 'foreach ' + render(p[1]) + '\n'
    s += ucpp.indent() + '{\n'
    ucpp.indentation += 1
    s += render(p[2])
    ucpp.indentation -= 1
    s += '\n' + ucpp.indent() + '}'
    return s


def r_vect(p):
    return 'vect(%s, %s, %s)' % tuple(map(render, p[1:4]))


def r_codeline(p):
    global ucpp
    return ucpp.indent() + '%s;' % render(p[1])


def r_start(p):
    return '\n\n'.join(render(q) for q in p[1])


def r_break_statement(p):
    return 'break'


def r_continue_statement(p):
    return 'continue'


def r_switch_statement(p):
    s = ucpp.indent() + 'switch (' + render(p[1]) + ')\n' + ucpp.indent() + '{\n'
    ucpp.indentation += 1
    s += '\n'.join(render(q) for q in p[2])
    ucpp.indentation -= 1
    s += '\n' + ucpp.indent() + '}'
    return s

def r_switch_case(p):
    s = ucpp.indent() + 'case ' + render(p[1]) + ':\n'
    ucpp.indentation += 1
    s += render(p[2])
    ucpp.indentation -= 1
    return s


def r_do_statement(p):
    s = ucpp.indent() + 'do\n' + ucpp.indent() + '{\n%s\n}' % render(p[1])
    if p[2] is not None:
        s = ' '.join([s, 'until (%s);' % render(p[2])])
    return s


def r_static_call(p):
    if len(p) == 2:
        return 'static.%s' % render(p[1])
    else:
        return '%s.static.%s' % (render(p[1]), render(p[2]))

def r_state_modifiers(p):
    if p[1] is not None:
        return ' '.join(p[1])
    return ''


def r_state_begin_block(p):
    return 'Begin:\n%s' % render(p[1])


def r_hidecategories(p):
    return 'hidecategories(' + render(p[1]) + ')'


def r_showcategories(p):
    return 'showcategories(' + render(p[1]) + ')'


def r_dependson(p):
    return 'dependson(' + render(p[1]) + ')'


def r_paren(p):
    return '()'


def r_state_definition(p):
    m = render(p[1])
    m = ' '.join(filter(lambda x: x != '', [m, 'state', render(p[2]), render(p[3]), render(p[4])]))
    m = m + '\n{\n'
    m = m + '\n'.join(map(lambda x: render(x), p[5:])) + '}'
    return m


def r_state_ignores(p):
    return 'ignores %s;' % render(p[1])


def r_while_statement(p):
    global ucpp
    s = ucpp.indent() + 'while (' + render(p[1]) + ')\n'
    s += ucpp.indent() + '{\n'
    ucpp.indentation += 1
    s += render(p[2])
    ucpp.indentation -= 1
    s += '\n' + ucpp.indent() + '}'
    return s


def r_global_call(p):
    return 'global.%s' % render(p[1])


def r_allocation(p):
    s = ['new']
    if p[1] is not None:
        s.append(render(p[1]))
    s.append(render(p[2]))
    return ' '.join(s)


def r_construction(p):
    return '(new %s).__ctor__(%s)' % (render(p[1]), render(p[2]))


def r_deep_type(p):
    return '.'.join(map(lambda x: render(x), p[1:]))


def r_extends(p):
    return ' '.join(['extends', render(p[1])])


def render(p):
    s = ''
    if p is None:
        return ''
    elif type(p) is int:
        return str(p)
    elif type(p) is str:
        return p
    elif type(p) is list:
        for q in p:
            rfunc = eval('r_{}'.format(q[0]))
            s += rfunc(q)
    elif type(p) is tuple:
        u = eval('r_{}'.format(p[0]))
        s += u(p)
    return s

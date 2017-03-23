from ply import lex
from subprocess import Popen, PIPE

primitive_types = {
    'float': 'FLOAT',
    'int': 'INT',
    'name': 'NAME',
    'bool': 'BOOL',
    'string': 'STRING',
    'byte': 'BYTE'
}

function_modifiers = [
    'EXEC',
    'FINAL',
    'ITERATOR',
    'LATENT',
    'NATIVE',
    'SIMULATED',
    'SINGULAR',
    'STATIC'
]

struct_modifers = [
    'TRANSIENT'
    'EXPORT'
    'INIT'
    'NATIVE'
]

class_modifiers = {
    'abstract': 'ABSTRACT',
    'cacheexempt': 'CACHEEXEMPT',
    'collapsecategories': 'COLLAPSECATEGORIES',
    'config': 'CONFIG',
    'dependson': 'DEPENDSON',
    'dontcollapsecategories': 'DONTCOLLAPSECATEGORIES',
    'editinlinenew': 'EDITINLINENEW',
    'exportstructs': 'EXPORTSTRUCTS',
    'hidecategories': 'HIDECATEGORIES',
    'hidedropdown': 'HIDEDROPDOWN',
    'instanced': 'INSTANCED',
    'native': 'NATIVE',
    'nativereplication': 'NATIVEREPLICATION',
    'noexport': 'NOEXPORT',
    'nonativereplication': 'NONATIVEREPLICATION',
    'noteditinlinenew': 'NOTEDITINLINENEW',
    'notplaceable': 'NOTPLACEABLE',
    'parseconfig': 'PARSECONFIG',
    'perobjectconfig': 'PEROBJECTCONFIG',
    'placeable': 'PLACEABLE',
    'safereplace': 'SAFEREPLACE',
    'showcategories': 'SHOWCATEGORIES',
    'transient': 'TRANSIENT',
    'within': 'WITHIN',
    'template': 'TEMPLATE'
}

access_modifiers = {
    'private': 'PRIVATE',
    'protected': 'PROTECTED'
}

function_parameter_modifiers = {
    'skip': 'SKIP',
    'out': 'OUT',
    'optional': 'OPTIONAL',
    'coerce': 'COERCE'
}

variable_modifiers = {
    'automated': 'AUTOMATED',
    'cache': 'CACHE',
    'config': 'CONFIG',
    'const': 'CONST',
    'deprecated': 'DEPRECATED',
    'edfindable': 'EDFINDABLE',
    'editconst': 'EDITCONST',
    'editconstarray': 'EDITCONSTARRAY',
    'editinline': 'EDITINLINE',
    'editinlinenotify': 'EDITINLINENOTIFY',
    'editinlineuse': 'EDITINLINEUSE',
    'export': 'EXPORT',
    'noexport': 'NOEXPORT',
    'globalconfig': 'GLOBALCONFIG',
    'input': 'INPUT',
    'localized': 'LOCALIZED',
    'native': 'NATIVE',
    'private': 'PRIVATE',
    'protected': 'PROTECTED',
    'transient': 'TRANSIENT',
    'travel': 'TRAVEL',
}

ucpp_keywords = {
    'GIT_BRANCH': 'GIT_BRANCH',
    'GIT_TAG': 'GIT_TAG',
    'GIT_COMMIT': 'GIT_COMMIT'
}

reserved = {
    'always': 'ALWAYS',
    'array': 'ARRAY',
    'arraycount': 'ARRAYCOUNT',
    'assert': 'ASSERT',
    'auto': 'AUTO',
    'automated': 'AUTOMATED',
    'begin': 'BEGIN',
    'bool': 'BOOL',
    'break': 'BREAK',
    'button': 'BUTTON',
    'byte': 'BYTE',
    'case': 'CASE',
    'class': 'CLASS',
    'coerce': 'COERCE',
    'collapsecategories': 'COLLAPSECATEGORIES',
    'constructor': 'CONSTRUCTOR',
    'continue': 'CONTINUE',
    'cross': 'CROSS',
    'defaultproperties': 'DEFAULTPROPERTIES',
    'delegate': 'DELEGATE',
    'do': 'DO',
    'dot': 'DOT',
    'editinlinenotify': 'EDITINLINENOTIFY',
    'editinlineuse': 'EDITINLINEUSE',
    'else': 'ELSE',
    'end': 'END',
    'enum': 'ENUM',
    'enumcount': 'ENUMCOUNT',
    'event': 'EVENT',
    'exec': 'EXEC',
    'expands': 'EXPANDS',
    'extends': 'EXTENDS',
    'false': 'FALSE',
    'final': 'FINAL',
    'float': 'FLOAT',
    'for': 'FOR',
    'foreach': 'FOREACH',
    'function': 'FUNCTION',
    'global': 'GLOBAL',
    'globalconfig': 'GLOBALCONFIG',
    'goto': 'GOTO',
    'if': 'IF',
    'ignores': 'IGNORES',
    'import': 'IMPORT',
    'init': 'INIT',
    'input': 'INPUT',
    #'insert': 'INSERT',
    'int': 'INT',
    'intrinsic': 'INTRINSIC',
    'invariant': 'INVARIANT',
    'iterator': 'ITERATOR',
    'latent': 'LATENT',
    'local': 'LOCAL',
    'localized': 'LOCALIZED',
    'name': 'NAME',
    'new': 'NEW',
    'none': 'NONE',
    'nousercreate': 'NOUSERCREATE',
    'object': 'OBJECT',
    'operator': 'OPERATOR',
    'optional': 'OPTIONAL',
    'out': 'OUT',
    'postoperator': 'POSTOPERATOR',
    'preoperator': 'PREOPERATOR',
    'reliable': 'RELIABLE',
    #'remove': 'REMOVE',
    'replication': 'REPLICATION',
    'return': 'RETURN',
    'rng': 'RNG',
    'rot': 'ROT',
    'self': 'SELF',
    'simulated': 'SIMULATED',
    'singular': 'SINGULAR',
    'skip': 'SKIP',
    'state': 'STATE',
    'static': 'STATIC',
    'stop': 'STOP',
    'string': 'STRING',
    'struct': 'STRUCT',
    'super': 'SUPER',
    'switch': 'SWITCH',
    'true': 'TRUE',
    'unreliable': 'UNRELIABLE',
    'until': 'UNTIL',
    'var': 'VAR',
    'vect': 'VECT',
    'while': 'WHILE',
    # the following are keywords added by ulex
    'typeof': 'TYPEOF'
}

reserved.update(class_modifiers)
reserved.update(variable_modifiers)
reserved.update(ucpp_keywords)

tokens = [
    'DEFAULT',
    'DEFAULT_LABEL',
    'COMMENT',
    'UNAME',
    'INTEGER',
    'HEX',
    'SEMICOLON',
    'LPAREN',
    'RPAREN',
    'LSQUARE',
    'RSQUARE',
    'LANGLE',
    'RANGLE',
    'LCURLY',
    'RCURLY',
    'ASSIGN',
    'COMMA',
    'PERIOD',
    'LQUOTE',
    'RQUOTE',
    'USTRING',
    'PSTRING',
    'UFLOAT',
    'EQUAL',
    'NEQUAL',
    'OR',
    'NOT',
    'INCREMENT',
    'DECREMENT',
    'ADD',
    'MULTIPLY',
    'AND',
    'MINUS',
    'COLON',
    'SEQUAL',
    'MODULUS',
    'SCONCAT',
    'SCONCATASSIGN',
    'SCONCATSPACE',
    'SCONCATSPACEASSIGN',
    'DIVIDE',
    'REFERENCE',
    'DIRECTIVE',
    'AMPERSAND',
    'BITWISE_AND',
    'BITWISE_OR',
    'LEFT_SHIFT',
    'RIGHT_SHIFT',
    'RIGHT_SHIFT_ARITHMETIC',
    'XOR',
    'BITWISE_NOT',
    'ID',
    'LEQUAL',
    'GEQUAL',
    'ADD_ASSIGN',
    'SUBTRACT_ASSIGN',
    'MULTIPLY_ASSIGN',
    'DIVIDE_ASSIGN',
    'POW',
    'LOGICAL_XOR'
] + list(reserved.values())

t_LPAREN = r'\('
t_RPAREN = r'\)'
t_LSQUARE = r'\['
t_RSQUARE = r'\]'
t_LANGLE = r'\<'
t_RANGLE = r'\>'
t_LCURLY = r'\{'
t_RCURLY = r'\}'
t_LQUOTE = r'\"'
t_RQUOTE = r'\"'
t_ignore = '\r\t '
t_SEMICOLON = r'\;'
t_ASSIGN = r'\='
t_COMMA = r','
t_PERIOD = '\.'
t_EQUAL = r'=='
t_NEQUAL = r'!='
t_OR = r'\|\|'
t_NOT = r'!'
t_INCREMENT = r'\+\+'
t_DECREMENT = r'\-\-'
t_ADD_ASSIGN = r'\+\='
t_SUBTRACT_ASSIGN = r'\-\='
t_MULTIPLY_ASSIGN = r'\*\='
t_DIVIDE_ASSIGN = r'\/\='
t_ADD = r'\+'
t_MULTIPLY = r'\*'
t_AND = r'\&\&'
t_MINUS = r'-'
t_COLON = r':'
t_SEQUAL = r'~='
t_MODULUS = r'%'
t_SCONCAT = r'\$'
t_SCONCATASSIGN = r'\$='
t_SCONCATSPACE = r'@'
t_SCONCATSPACEASSIGN = r'@='
t_DIVIDE = r'/'
t_BITWISE_AND = r'\&'
t_BITWISE_OR = r'\|'
t_LEFT_SHIFT = r'\<\<'
t_RIGHT_SHIFT_ARITHMETIC = r'\>\>'
t_RIGHT_SHIFT = r'\>\>\>'
t_XOR = r'\^'
t_LOGICAL_XOR = r'\^\^'
t_BITWISE_NOT = r'~'
t_LEQUAL = r'\<\='
t_GEQUAL = r'\>\='
t_POW = r'\*\*'


def t_DEFAULT(t):
    r'default\s*\.'
    return t


def t_DEFAULT_LABEL(t):
    r'default\s*:'
    return t


def t_DIRECTIVE(t):
    r'\#(\w+)\s+(.+)'
    return t


def t_REFERENCE(t):
    r'([a-zA-Z0-9_\-]+)\'([a-zA-Z0-9_\-\.\&]+)\''
    return t


def t_UNAME(t):
    r'\'([a-zA-Z0-9_\- ]*)\''
    return t


def t_USTRING(t):
    r'"((\\{2})*|(.*?[^\\](\\{2})*))"'
    return t


def t_PSTRING(t):
    r'\@"((\\{2})*|(.*?[^\\](\\{2})*))"'
    t.value = t.value[2:-1]
    return t


def t_UFLOAT(t):
    r'[-+]?\d*?[.]\d+'
    t.value = float(t.value)
    return t


def t_HEX(t):
    r'0[xX][0-9a-fA-F]+'
    t.type = 'INTEGER'
    t.value = int(t.value, 0)
    return t


def t_INTEGER(t):
    r'[-+]?\d+'
    t.value = int(t.value)
    return t


def t_COMMENT(t):
    r'(/\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+/)|(//.*)'


def t_ID(t):
    r'[a-zA-Z_][a-zA-Z_0-9]*'
    t.type = reserved.get(t.value.lower(), 'ID')
    return t


def t_newline(t):
    r'\n+'
    t.lexer.lineno += len(t.value)


def t_error(t):
    pass


def t_MACRO(t):
    r'\{\%GIT_TAG\%\}'
    p = Popen(['git', 'describe', '--abbrev=0', '--tags'], stdout=PIPE, stderr=PIPE, stdin=PIPE)
    t.type = 'USTRING'
    t.value = '"' + p.stdout.read().strip() + '"'
    return t


lexer = lex.lex(debug=False)

%%

%public

%{
  private int comment_count = 0;
%}

%class XmC
%line
%char
%state COMMENT
%unicode

%debug

ALPHA=[A-Za-z]

DIGIT=[0-9]

NONNEWLINE_WHITE_SPACE_CHAR=[\ \t\b\012]

NEWLINE=\r|\n|\r\n

WHITE_SPACE_CHAR=[\n\r\ \t\b\012]

STRING_TEXT=(\\\"|[^\n\r\"]|\\{WHITE_SPACE_CHAR}+\\)*

COMMENT_TEXT=([^*/\n]|[^*\n]"/"[^*\n]|[^/\n]"*"[^/\n]|"*"[^/\n]|"/"[^*\n])+

Ident = {ALPHA}({ALPHA}|{DIGIT}|_)*

%%

<YYINITIAL> {

/* Operators */

  "," { return (new Yytoken(0,yytext(),yyline,yychar,yychar+1)); }
  ":" { return (new Yytoken(1,yytext(),yyline,yychar,yychar+1)); }
  ";" { return (new Yytoken(2,yytext(),yyline,yychar,yychar+1)); }
  "(" { return (new Yytoken(3,yytext(),yyline,yychar,yychar+1)); }
  ")" { return (new Yytoken(4,yytext(),yyline,yychar,yychar+1)); }
  "[" { return (new Yytoken(5,yytext(),yyline,yychar,yychar+1)); }
  "]" { return (new Yytoken(6,yytext(),yyline,yychar,yychar+1)); }
  "{" { return (new Yytoken(7,yytext(),yyline,yychar,yychar+1)); }
  "}" { return (new Yytoken(8,yytext(),yyline,yychar,yychar+1)); }
  "." { return (new Yytoken(9,yytext(),yyline,yychar,yychar+1)); }
  "+" { return (new Yytoken(10,yytext(),yyline,yychar,yychar+1)); }
  "-" { return (new Yytoken(11,yytext(),yyline,yychar,yychar+1)); }
  "*" { return (new Yytoken(12,yytext(),yyline,yychar,yychar+1)); }
  "/" { return (new Yytoken(13,yytext(),yyline,yychar,yychar+1)); }
  "=" { return (new Yytoken(14,yytext(),yyline,yychar,yychar+1)); }
  "<>" { return (new Yytoken(15,yytext(),yyline,yychar,yychar+2)); }
  "<"  { return (new Yytoken(16,yytext(),yyline,yychar,yychar+1)); }
  "<=" { return (new Yytoken(17,yytext(),yyline,yychar,yychar+2)); }
  ">"  { return (new Yytoken(18,yytext(),yyline,yychar,yychar+1)); }
  ">=" { return (new Yytoken(19,yytext(),yyline,yychar,yychar+2)); }
  "&"  { return (new Yytoken(20,yytext(),yyline,yychar,yychar+1)); }
  "|"  { return (new Yytoken(21,yytext(),yyline,yychar,yychar+1)); }
  ":=" { return (new Yytoken(22,yytext(),yyline,yychar,yychar+2)); }
  "+=" { return (new Yytoken(23,yytext(),yyline,yychar,yychar+2)); }
  "-=" { return (new Yytoken(24,yytext(),yyline,yychar,yychar+2)); }
  "/=" { return (new Yytoken(25,yytext(),yyline,yychar,yychar+2)); }
  "*=" { return (new Yytoken(26,yytext(),yyline,yychar,yychar+2)); }
  "==" { return (new Yytoken(50,yytext(),yyline,yychar,yychar+2)); }



  /* keywords */
 
  "void" { return (new Yytoken(27,yytext(),yyline,yychar,yychar+4)); }
  "char" { return (new Yytoken(28,yytext(),yyline,yychar,yychar+4)); }
  "short" { return (new Yytoken(29,yytext(),yyline,yychar,yychar+5)); }
  "int" { return (new Yytoken(30,yytext(),yyline,yychar,yychar+3)); }
  "long" { return (new Yytoken(31,yytext(),yyline,yychar,yychar+4)); }
  "signed" { return (new Yytoken(32,yytext(),yyline,yychar,yychar+6)); }
  "unsigned" { return (new Yytoken(33,yytext(),yyline,yychar,yychar+8)); }
  "float" { return (new Yytoken(34,yytext(),yyline,yychar,yychar+5)); }
  "double" { return (new Yytoken(35,yytext(),yyline,yychar,yychar+5)); }
  "boolean" { return (new Yytoken(51,yytext(),yyline,yychar,yychar+7)); }

  "continue" { return (new Yytoken(36,yytext(),yyline,yychar,yychar+8)); }
  "return" { return (new Yytoken(37,yytext(),yyline,yychar,yychar+6)); }
  "break" { return (new Yytoken(38,yytext(),yyline,yychar,yychar+4)); }
  "if" { return (new Yytoken(39,yytext(),yyline,yychar,yychar+2)); }

  {NONNEWLINE_WHITE_SPACE_CHAR}+ { }

  "/*" { yybegin(COMMENT); comment_count++; }

  \"{STRING_TEXT}\" {
    String str =  yytext().substring(1,yylength()-1);
    return (new Yytoken(40,str,yyline,yychar,yychar+yylength()));
  }

  \"{STRING_TEXT} {
    String str =  yytext().substring(1,yytext().length());
    Utility.error(Utility.E_UNCLOSEDSTR);
    return (new Yytoken(41,str,yyline,yychar,yychar + str.length()));
  }

  /* Digits or Numbers */

  {DIGIT}+ { return (new Yytoken(42,yytext(),yyline,yychar,yychar+yylength())); }

  /* Identifiers */

  {Ident} { return (new Yytoken(43,yytext(),yyline,yychar,yychar+yylength())); }
}

/* comments */

<COMMENT> {
  "/*" { comment_count++; }
  "*/" { if (--comment_count == 0) yybegin(YYINITIAL); }
  {COMMENT_TEXT} { }
}

{NEWLINE} { }

. {
  System.out.println("Illegal character: <" + yytext() + ">");
  Utility.error(Utility.E_UNMATCHED);
}


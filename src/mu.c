#include <stdio.h>
#include <stdbool.h>  // For bool, true, false
#include <string.h>  // For strcmp()

#include <tree_sitter/api.h>

#include <utf8lex.h>

extern utf8lex_error_t yylex_settings(
        utf8lex_settings_t *settings
        );
extern utf8lex_error_t yylex_start(
        unsigned char *path
        );
extern int yyutf8lex(
        utf8lex_token_t *token_or_null,
        utf8lex_lloc_t *location_or_null
        );
extern utf8lex_error_t yylex_end();


/* !!!
const char *mu_read_token(
    void *payload,
    uint32_t byte_offset,
    TSPoint position,
    uint32_t *bytes_read
    )
{
  !!!;
}

uint32_t mu_decode(
    const uint8_t *string,
    uint32_t length,
    int32_t *code_point
    )
{
  !!!;
}

int mu_parse(int argc, char *argv[])
{
  if (argc != 2)
  {
    fprintf(stderr, "Usage: %s (input_file)\n",
            argv[0]);
    fprintf(stderr, "\n");
    fprintf(stderr, "(input_file):\n");
    fprintf(stderr, "    A text file to analyze with the linked lexer.\n");
    fprintf(stderr, "\n");
    fflush(stdout);
    fflush(stderr);
    return 1;
  }

  char *input_file_path = argv[1];

  utf8lex_error_t error;

  unsigned char token_str[4096];
  unsigned char printable_str[4096];

  error = yylex_start(input_file_path);
  if (error != UTF8LEX_OK)
  {
    unsigned char error_name[256];
    error_name[0] = '\0';
    utf8lex_string_t error_string;
    utf8lex_error_t string_error = utf8lex_string(&error_string, 256, error_name);
    string_error = utf8lex_error_string(&error_string, error);
    fprintf(stderr, "ERROR Failed yylex_start(\"%s\"): %d %s\n",
            input_file_path,
            (int) error,
            error_name);
    fflush(stdout);
    fflush(stderr);
    return (int) error;
  }

  // Create a parser.
  TSParser *parser = ts_parser_new();

  // Set the parser's language (JSON in this case).
  ts_parser_set_language(parser, tree_sitter_json());

  TSInput input;
  input.payload = !!!;  // void *payload;
  input.read = mu_read_token;
  input.encoding = TSInputEncodingCustom;
  input.decode = mu_decode;

  // Build a syntax tree based on source code stored in a string.
  TSTree *tree = ts_parser_parse(
    parser,  // self
    NULL,    // old_tree
    &input   // input
  );

  utf8lex_token_t token;
  utf8lex_lloc_t location;
  int lex_result = 0;
  while (lex_result >= 0)
  {
    lex_result = yyutf8lex(&token, &location);
    if (lex_result == YYEOF)
    {
      printf("EOF\n");
    }
    else if (lex_result == YYerror)
    {
      fprintf(stderr, "ERROR %d\n",
              lex_result);
    }
    else if (lex_result < 0)
    {
      fprintf(stderr, "UNKNOWN %d\n",
              lex_result);
    }
    else
    {
      error = utf8lex_token_copy_string(&token,  // self
                                        token_str,  // str
                                        (size_t) 4096);  // max_bytes
      if (error != UTF8LEX_OK)
      {
        fflush(stdout);
        fflush(stderr);
        return (int) error;
      }
      error = utf8lex_printable_str(printable_str,  // printable_str
                                    (size_t) 4096,  // max_bytes
                                    token_str,  // str
                                    UTF8LEX_PRINTABLE_ALL);  // flags
      if (error != UTF8LEX_OK)
      {
        fflush(stdout);
        fflush(stderr);
        return (int) error;
      }

      printf("TOKEN: %s \"%s\" (%s)\n",
              token.rule->definition->name,
              printable_str,
              token.rule->name);
    }
  }

  error = yylex_end();
  if (error != UTF8LEX_OK)
  {
    fprintf(stderr, "ERROR Failed yylex_end(): %d\n",
            (int) error);
    fflush(stdout);
    fflush(stderr);
    return (int) error;
  }

  fflush(stdout);
  fflush(stderr);

  // Get the root node of the syntax tree.
  TSNode root_node = ts_tree_root_node(tree);

  // Print the syntax tree as an S-expression.
  char *string = ts_node_string(root_node);
  printf("Syntax tree: %s\n", string);
  fflush(stdout);
  fflush(stderr);

  // Free all of the heap-allocated memory.
  free(string);
  ts_tree_delete(tree);
  ts_parser_delete(parser);
  fflush(stdout);
  fflush(stderr);

  return 0;
}
!!! */

int main(int argc, char *argv[])
{
  utf8lex_settings_t settings;
  utf8lex_settings_init(&settings,    // self
                        NULL,         // input_filename
                        NULL,         // output_filename
                        false);       // is_tracing

  
  unsigned char *input_file_path = NULL;
  for (int a = 1; a < argc; a ++)
  {
    if (a == (argc - 1))
    {
      input_file_path = argv[a];
      settings.input_filename = input_file_path;
    }
    else if (strcmp("--tracing", argv[a]) == 0)
    {
      settings.is_tracing = true;
    }
    else
    {
      fprintf(stderr, "ERROR Unrecognized option: '%s'.\n", argv[a]);
    }
  }

  if (input_file_path == NULL)
  {
    fprintf(stderr, "Usage: %s (input_file)\n",
            argv[0]);
    fprintf(stderr, "\n");
    fprintf(stderr, "(option):\n");
    fprintf(stderr, "    --tracing:\n");
    fprintf(stderr, "        Enables stdout tracing through definitions and rules.\n");
    fprintf(stderr, "\n");
    fprintf(stderr, "(input_file):\n");
    fprintf(stderr, "    A text file to analyze with the linked lexer.\n");
    fprintf(stderr, "\n");
    fflush(stdout);
    fflush(stderr);
    return 1;
  }

  utf8lex_error_t error;

  unsigned char token_str[4096];
  unsigned char printable_str[4096];

  error = yylex_settings(&settings);
  if (error != UTF8LEX_OK)
  {
    unsigned char error_name[256];
    error_name[0] = '\0';
    utf8lex_string_t error_string;
    utf8lex_error_t string_error = utf8lex_string(&error_string, 256, error_name);
    string_error = utf8lex_error_string(&error_string, error);
    fprintf(stderr, "ERROR Failed yylex_settings(...): %d %s\n",
            (int) error,
            error_name);
    fflush(stdout);
    fflush(stderr);
    return (int) error;
  }

  error = yylex_start(input_file_path);
  if (error != UTF8LEX_OK)
  {
    unsigned char error_name[256];
    error_name[0] = '\0';
    utf8lex_string_t error_string;
    utf8lex_error_t string_error = utf8lex_string(&error_string, 256, error_name);
    string_error = utf8lex_error_string(&error_string, error);
    fprintf(stderr, "ERROR Failed yylex_start(\"%s\"): %d %s\n",
            input_file_path,
            (int) error,
            error_name);
    fflush(stdout);
    fflush(stderr);
    return (int) error;
  }

  utf8lex_token_t token;
  utf8lex_lloc_t location;
  int lex_result = 0;
  while (lex_result >= 0)
  {
    lex_result = yyutf8lex(&token, &location);
    if (lex_result == YYEOF)
    {
      printf("EOF\n");
    }
    else if (lex_result == YYerror)
    {
      fprintf(stderr, "ERROR at [%d.%d] error code: %d\n",
              location.start_line + 1,
              location.start_char,
              lex_result);
    }
    else if (lex_result < 0)
    {
      fprintf(stderr, "UNKNOWN result at [%d.%d] error code: %d\n",
              location.start_line + 1,
              location.start_char,
              lex_result);
    }
    else
    {
      error = utf8lex_token_copy_string(&token,  // self
                                        token_str,  // str
                                        (size_t) 4096);  // max_bytes
      if (error != UTF8LEX_OK)
      {
        fflush(stdout);
        fflush(stderr);
        return (int) error;
      }

      error = utf8lex_printable_str(printable_str,  // printable_str
                                    (size_t) 4096,  // max_bytes
                                    token_str,  // str
                                    UTF8LEX_PRINTABLE_ALL);  // flags
      if (error != UTF8LEX_OK)
      {
        fflush(stdout);
        fflush(stderr);
        return (int) error;
      }

      printf("TOKEN: %s \"%s\" (%s)\n",
             token.rule->definition->name,
             printable_str,
             token.rule->name);
      fflush(stdout);
    }
  }

  error = yylex_end();
  if (error != UTF8LEX_OK)
  {
    fprintf(stderr, "ERROR Failed yylex_end(): %d\n",
            (int) error);
    fflush(stdout);
    fflush(stderr);
    return (int) error;
  }

  fflush(stdout);
  fflush(stderr);

  return 0;
}

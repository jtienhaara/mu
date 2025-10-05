/*
 * mu language.
 *
 * Copyright © 2025 Johann Tienhaara
 * All rights reserved
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

Term: BuiltinType;
Type: BuiltinType;

Declaration: BuiltinType(
    arguments: Expression[0..n],
    returns: Expression[0..n]
    );
Body: BuiltinType(
    expressions: Expression[0..n]
    );

LexDefinition: BuiltinType;
LexRule: BuiltinType;
GrammarRule: BuiltinType;
Syntax: BuiltinType(
    lexicon: LexDefinition[0..n],
    rules: LexRule[0..n],
    grammar: GrammarRule[0..n]
    );

OperatorUnary: Syntax(
  lexicon = {
    OP_ASSIGN_DECREMENT             "--"
    OP_ASSIGN_INCREMENT             "++"
    OP_AT                           "@"
    OP_DOLLAR                       "$"
    OP_HASH                         "#"
    OP_NOT                          "!"
  },
  rules = {
  }
  );
OperatorBinary: Syntax(
  lexicon = {
    OP_ASSIGN_AND_AND               "&&="
    OP_AND_AND                      "&&"
    OP_ASSIGN_AND                   "&="
    OP_AND                          "&"
    OP_ASSIGN                       "="
    OP_ASSIGN_DIVIDE                "/="
    OP_ASSIGN_MINUS                 "-="
    OP_ASSIGN_MODULO                "%="
    OP_ASSIGN_OR                    "|="
    OP_ASSIGN_OR_OR                 "||="
    OP_ASSIGN_PLUS                  "+="
    OP_ASSIGN_POWER                 "**="
    OP_ASSIGN_TIMES                 "*="
    OP_ASSIGN_XOR                   "^="
    OP_ASSIGN_XOR_XOR               "^^="
    OP_DIVIDED_BY                   "/"
    OP_EQUAL                        "=="
    OP_GREATER_THAN_EQUAL           ">="
    OP_GREATER_THAN                 ">"
    OP_LESS_THAN_EQUAL              "<="
    OP_LESS_THAN                    "<"
    OP_MINUS                        "-"
    OP_MODULO                       "%"
    OP_NOT_EQUAL                    "!="
    OP_OR                           "|"
    OP_OR_OR                        "||"
    OP_PLUS                         "+"
    OP_POWER                        "**"
    OP_TILDE                        "~"
    OP_TILDE_EQUAL                  "~="
    OP_TIMES                        "*"
    OP_XOR                          "^"
    OP_XOR_XOR                      "^^"
  },
  rules = {
  }
  );
OperatorTernary1: Syntax(
  lexicon = {
    OP_QUESTION                     "?"
  },
  rules = {
  }
  );
OperatorTernary2: Syntax(
  lexicon = {
    OP_COLON                        ":"
  },
  rules = {
  }
  );

Expression: Grammar(
  grammar = {
    left: Term, op: OperatorUnary
    | left: Term, op: OperatorBinary, right: Term
    | left: Term, op: OperatorTernary1, middle: Term, op: OperatorTernary2, right: Term
  }
  );

# Dicionário de dados (colunas usadas nos scripts)

Fonte: dicionário de dados dos Microdados do Censo Escolar 2025 (INEP). Descrições resumidas; consulte o dicionário oficial para os códigos completos.

| Coluna | Tabela de origem | Tipo | Descrição |
|---|---|---|---|
| `CO_ENTIDADE` | docente_2025 | INT64 | Código INEP da escola (chave) |
| `CO_MUNICIPIO` | docente_2025 | INT64 | Código IBGE do município (3304557 = Rio de Janeiro) |
| `CO_ORGAO_REGIONAL` | escola_2025 | STRING | Código do órgão regional (CRE, na rede municipal) |
| `IN_ACESSIBILIDADE_INEXISTENTE` | escola_2025 | INT64 | Escola sem recursos de acessibilidade (0/1) |
| `IN_ACESSIBILIDADE_RAMPAS` | escola_2025 | INT64 | Possui rampas de acesso (0/1) |
| `IN_AGUA_POTAVEL` | escola_2025 | INT64 | Fornece água potável (0/1) |
| `IN_BANHEIRO_PNE` | escola_2025 | INT64 | Banheiro acessível a pessoas com deficiência ou mobilidade reduzida (0/1) |
| `IN_BIBLIOTECA` | escola_2025 | INT64 | Possui biblioteca (0/1) |
| `IN_BIBLIOTECA_SALA_LEITURA` | escola_2025 | INT64 | Possui biblioteca ou sala de leitura (0/1) |
| `IN_ENERGIA_REDE_PUBLICA` | escola_2025 | INT64 | Energia elétrica da rede pública (0/1) |
| `IN_ESGOTO_REDE_PUBLICA` | escola_2025 | INT64 | Esgoto na rede pública (0/1) |
| `IN_INTERNET` | escola_2025 | INT64 | Possui acesso à internet (0/1) |
| `IN_LABORATORIO_CIENCIAS` | escola_2025 | INT64 | Possui laboratório de ciências (0/1) |
| `IN_LABORATORIO_INFORMATICA` | escola_2025 | INT64 | Possui laboratório de informática (0/1) |
| `IN_SALA_ATENDIMENTO_ESPECIAL` | escola_2025 | INT64 | Possui sala de recursos multifuncionais (0/1) |
| `NO_ENTIDADE` | docente_2025 | STRING | Nome da escola |
| `NU_ANO_CENSO` | docente_2025 | INT64 | Ano de referência do Censo |
| `QT_DOC_BAS` | docente_2025 | INT64 | Docentes na educação básica |
| `QT_DOC_BAS_ESCO_SUP_GRAD` | docente_2025 | INT64 | Docentes com graduação |
| `QT_GEST_BAS` | gestor_2025 | INT64 | Gestores |
| `QT_GEST_BAS_ACESSO_CARGO_CONC` | gestor_2025 | INT64 | Gestores com acesso ao cargo por concurso |
| `QT_GEST_BAS_DIRETOR` | gestor_2025 | INT64 | Gestores no cargo de diretor |
| `QT_MAT_BAS` | matricula_2025 | INT64 | Matrículas na educação básica |
| `QT_MAT_BAS_AMARELA` | matricula_2025 | INT64 | Matrículas — cor/raça amarela |
| `QT_MAT_BAS_BRANCA` | matricula_2025 | INT64 | Matrículas — cor/raça branca |
| `QT_MAT_BAS_FEM` | matricula_2025 | INT64 | Matrículas — sexo feminino |
| `QT_MAT_BAS_INDIGENA` | matricula_2025 | INT64 | Matrículas — cor/raça indígena |
| `QT_MAT_BAS_MASC` | matricula_2025 | INT64 | Matrículas — sexo masculino |
| `QT_MAT_BAS_ND` | matricula_2025 | INT64 | Matrículas — cor/raça não declarada |
| `QT_MAT_BAS_PARDA` | matricula_2025 | INT64 | Matrículas — cor/raça parda |
| `QT_MAT_BAS_PRETA` | matricula_2025 | INT64 | Matrículas — cor/raça preta |
| `QT_MAT_EJA` | matricula_2025 | INT64 | Matrículas na EJA |
| `QT_MAT_EJA_FUND` | matricula_2025 | INT64 | Matrículas na EJA fundamental |
| `QT_MAT_ESP` | matricula_2025 | INT64 | Matrículas da educação especial |
| `QT_MAT_FUND_AF` | matricula_2025 | INT64 | Matrículas nos anos finais |
| `QT_MAT_FUND_AI` | matricula_2025 | INT64 | Matrículas nos anos iniciais |
| `QT_MAT_INF_CRE` | matricula_2025 | INT64 | Matrículas em creche |
| `QT_MAT_INF_PRE` | matricula_2025 | INT64 | Matrículas na pré-escola |
| `QT_TUR_BAS` | turmas_2025 | INT64 | Turmas na educação básica |
| `QT_TUR_EJA_FUND` | turmas_2025 | INT64 | Turmas de EJA fundamental |
| `QT_TUR_FUND_AF` | turmas_2025 | INT64 | Turmas dos anos finais |
| `QT_TUR_FUND_AI` | turmas_2025 | INT64 | Turmas dos anos iniciais |
| `QT_TUR_INF_CRE` | turmas_2025 | INT64 | Turmas de creche |
| `QT_TUR_INF_PRE` | turmas_2025 | INT64 | Turmas de pré-escola |
| `TP_AEE` | escola_2025 | INT64 | Oferta de Atendimento Educacional Especializado |
| `TP_DEPENDENCIA` | docente_2025 | INT64 | Dependência administrativa (1 Federal, 2 Estadual, 3 Municipal, 4 Privada) |
| `TP_LOCALIZACAO` | docente_2025 | INT64 | Localização (1 Urbana, 2 Rural) |
| `TP_SITUACAO_FUNCIONAMENTO` | escola_2025 | INT64 | Situação de funcionamento (1 Em atividade, 2 Paralisada, 3 Extinta, 4 Extinta em anos anteriores) |

## Volume da carga (Bronze, 2025)

| Tabela | Linhas | Colunas |
|---|---|---|
| escola_2025 | 4.057 | 290 |
| matricula_2025 | 3.875 | 263 |
| turmas_2025 | 3.875 | 218 |
| docente_2025 | 3.875 | 184 |
| gestor_2025 | 3.897 | 88 |
| **Total** | **19.579** | **1.043** |

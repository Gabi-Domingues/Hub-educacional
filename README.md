# Hub Educacional — Censo Escolar no Datalake do Rio de Janeiro

Scripts do piloto apresentado na monografia **"A transformação digital na educação: o Datalake do Rio de Janeiro como infraestrutura pública digital para a gestão educacional baseada em evidências"** (MBA em Engenharia de Dados — Escola Politécnica/UFRJ, 2026), de Gabrielle Freire Domingues.

O repositório permite reproduzir, a partir de dados **públicos**, as camadas Bronze, Silver e Gold e os indicadores do dashboard estratégico.

## Fonte dos dados

Microdados do Censo Escolar da Educação Básica 2025, publicados pelo INEP:
<https://www.gov.br/inep/pt-br/acesso-a-informacao/dados-abertos/microdados/censo-escolar>

- Os dados são **agregados por escola** (1 linha = 1 escola). Não há registros individuais de alunos, docentes ou gestores.
- Recorte usado: município do Rio de Janeiro (`CO_MUNICIPIO = 3304557`).
- Nenhum dado é versionado neste repositório. Apenas os scripts.

Para a série histórica e a taxa de abandono, usam-se tabelas públicas da [Base dos Dados](https://basedosdados.org), que redistribuem dados do INEP no BigQuery:

| Tabela | Cobertura | Uso |
|---|---|---|
| `basedosdados.br_inep_censo_escolar.escola` | 2007–2025 | Número de unidades escolares por ano |
| `basedosdados.br_inep_censo_escolar.matricula` | 2007–2020 | Matrículas por ano (microdados por matrícula) |
| `basedosdados.br_inep_indicadores_educacionais.municipio` | 2006–2024 | Taxa de abandono do ensino fundamental |

## Arquitetura

| Camada | Dataset no BigQuery | Conteúdo |
|---|---|---|
| Bronze | `censoescolar` | Tabelas do INEP sem transformação: `escola_2025`, `matricula_2025`, `turmas_2025`, `docente_2025`, `gestor_2025` |
| Silver | `censoescolar_silver` | Rede municipal (`TP_DEPENDENCIA = 3`), colunas renomeadas, nulos tratados |
| Gold | `censoescolar_gold` | Modelo dimensional (fact constellation) consumido pelo Power BI |

## Como reproduzir

1. Baixe os microdados do Censo Escolar 2025 no portal do INEP.
2. Filtre o município do Rio de Janeiro (`CO_MUNICIPIO = 3304557`) e carregue cada tabela no BigQuery, no dataset `censoescolar` (no piloto, a carga foi feita a partir do Google Drive).
3. Troque o projeto `rj-sme-dev` pelo seu projeto do Google Cloud nos scripts.
4. Execute os scripts na ordem:

| Script | O que faz |
|---|---|
| `sql/01_bronze_validacao.sql` | Volume, recorte, duplicidade, integridade e nulos da carga |
| `sql/02_silver.sql` | Cria as tabelas Silver da rede municipal |
| `sql/03_gold_modelo.sql` | Cria dimensões e fatos da camada Gold |
| `sql/04_kpis.sql` | Calcula os indicadores apresentados no dashboard |
| `sql/05_reconciliacao.sql` | Confere os totais entre Bronze, Silver e Gold |
| `sql/06_serie_historica.sql` | Série histórica de unidades e matrículas da rede municipal |
| `sql/07_taxa_abandono.sql` | Série da taxa de abandono do ensino fundamental, 2015–2024 |

## Indicadores implementados no piloto

| Indicador | Fonte | Script |
|---|---|---|
| Total de matrículas, por sexo, etapa e CRE | `matricula_2025` | `04_kpis.sql` (4.1 a 4.3) |
| Média de alunos por turma | `matricula_2025`, `turmas_2025` | `04_kpis.sql` (4.5) |
| % de matrículas EJA por CRE | `matricula_2025`, `escola_2025` | `04_kpis.sql` (4.6) |
| Educação especial (AEE, sala de recursos, matrículas) | `escola_2025`, `matricula_2025` | `04_kpis.sql` (4.7) |
| Taxa de abandono no ensino fundamental (rede municipal) | Indicadores Educacionais do INEP (via Base dos Dados) | `07_taxa_abandono.sql` |

## Limitações conhecidas

- **Taxa de abandono:** não está nos microdados do Censo Escolar; vem dos Indicadores Educacionais do INEP (via Base dos Dados). Na Base dos Dados, os anos de 2023 e 2024 não passam na regra de qualidade (aprovação + reprovação + abandono = 100%) e foram excluídos da camada Gold; 2020 não tem dado. A série validada cobre 2015–2019 e 2021–2022.
- **Série histórica de matrículas:** os microdados por matrícula vão até 2020. De 2021 a 2024, o INEP publica apenas dados agregados por escola, que não foram integrados nesta versão.
- **Critérios de contagem:** podem variar entre edições do Censo (por exemplo, inclusão de turmas de AEE e atividade complementar). O script 06 detalha as matrículas por tipo de atendimento para permitir essa conferência.
- **CRE:** usa o campo `CO_ORGAO_REGIONAL` do cadastro da escola.

## Dicionário de dados

Ver [`docs/dicionario_dados.md`](docs/dicionario_dados.md).

## Como citar

DOMINGUES, G. F. **A transformação digital na educação: o Datalake do Rio de Janeiro como infraestrutura pública digital para a gestão educacional baseada em evidências**. Monografia (MBA em Engenharia de Dados) — Escola Politécnica, Universidade Federal do Rio de Janeiro, Rio de Janeiro, 2026.

## Licença

Scripts sob licença MIT. Os dados pertencem ao INEP e seguem os termos de uso do portal de dados abertos.

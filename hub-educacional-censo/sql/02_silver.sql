-- =====================================================================
-- 02 | CAMADA SILVER — limpeza, padronização e recorte da rede municipal
-- Regras:
--   * rede municipal do Rio de Janeiro: CO_MUNICIPIO = 3304557 e TP_DEPENDENCIA = 3
--   * nomes de colunas em snake_case
--   * contagens nulas tratadas como zero (etapa não ofertada)
-- =====================================================================

CREATE SCHEMA IF NOT EXISTS `rj-sme-dev.censoescolar_silver`;

CREATE OR REPLACE TABLE `rj-sme-dev.censoescolar_silver.escola` AS
SELECT
  NU_ANO_CENSO                 AS ano,
  CO_ENTIDADE                  AS id_escola,
  NO_ENTIDADE                  AS nome_escola,
  CO_ORGAO_REGIONAL            AS id_cre,
  TP_LOCALIZACAO               AS tp_localizacao,
  TP_SITUACAO_FUNCIONAMENTO    AS tp_situacao_funcionamento,
  TP_SITUACAO_FUNCIONAMENTO = 1 AS em_atividade,
  TP_AEE                       AS tp_aee,
  IN_SALA_ATENDIMENTO_ESPECIAL AS in_sala_recursos,
  IN_BIBLIOTECA                AS in_biblioteca,
  IN_BIBLIOTECA_SALA_LEITURA   AS in_biblioteca_sala_leitura,
  IN_LABORATORIO_INFORMATICA   AS in_lab_informatica,
  IN_LABORATORIO_CIENCIAS      AS in_lab_ciencias,
  IN_ACESSIBILIDADE_RAMPAS     AS in_rampas,
  IN_BANHEIRO_PNE              AS in_banheiro_pne,
  IN_ACESSIBILIDADE_INEXISTENTE AS in_sem_acessibilidade,
  IN_INTERNET                  AS in_internet,
  IN_AGUA_POTAVEL              AS in_agua_potavel,
  IN_ENERGIA_REDE_PUBLICA      AS in_energia_rede_publica,
  IN_ESGOTO_REDE_PUBLICA       AS in_esgoto_rede_publica
FROM `rj-sme-dev.censoescolar.escola_2025`
WHERE CO_MUNICIPIO = 3304557
  AND TP_DEPENDENCIA = 3;

CREATE OR REPLACE TABLE `rj-sme-dev.censoescolar_silver.matricula` AS
SELECT
  NU_ANO_CENSO              AS ano,
  CO_ENTIDADE               AS id_escola,
  IFNULL(QT_MAT_BAS, 0)     AS qt_mat_basica,
  IFNULL(QT_MAT_INF_CRE, 0) AS qt_mat_creche,
  IFNULL(QT_MAT_INF_PRE, 0) AS qt_mat_pre_escola,
  IFNULL(QT_MAT_FUND_AI, 0) AS qt_mat_anos_iniciais,
  IFNULL(QT_MAT_FUND_AF, 0) AS qt_mat_anos_finais,
  IFNULL(QT_MAT_EJA_FUND, 0) AS qt_mat_eja_fundamental,
  IFNULL(QT_MAT_EJA, 0)     AS qt_mat_eja,
  IFNULL(QT_MAT_ESP, 0)     AS qt_mat_educacao_especial,
  IFNULL(QT_MAT_BAS_FEM, 0) AS qt_mat_feminino,
  IFNULL(QT_MAT_BAS_MASC, 0) AS qt_mat_masculino,
  IFNULL(QT_MAT_BAS_ND, 0)  AS qt_mat_cor_nd,
  IFNULL(QT_MAT_BAS_BRANCA, 0) AS qt_mat_branca,
  IFNULL(QT_MAT_BAS_PRETA, 0)  AS qt_mat_preta,
  IFNULL(QT_MAT_BAS_PARDA, 0)  AS qt_mat_parda,
  IFNULL(QT_MAT_BAS_AMARELA, 0) AS qt_mat_amarela,
  IFNULL(QT_MAT_BAS_INDIGENA, 0) AS qt_mat_indigena
FROM `rj-sme-dev.censoescolar.matricula_2025`
WHERE CO_MUNICIPIO = 3304557
  AND TP_DEPENDENCIA = 3;

CREATE OR REPLACE TABLE `rj-sme-dev.censoescolar_silver.turma` AS
SELECT
  NU_ANO_CENSO               AS ano,
  CO_ENTIDADE                AS id_escola,
  IFNULL(QT_TUR_BAS, 0)      AS qt_tur_basica,
  IFNULL(QT_TUR_INF_CRE, 0)  AS qt_tur_creche,
  IFNULL(QT_TUR_INF_PRE, 0)  AS qt_tur_pre_escola,
  IFNULL(QT_TUR_FUND_AI, 0)  AS qt_tur_anos_iniciais,
  IFNULL(QT_TUR_FUND_AF, 0)  AS qt_tur_anos_finais,
  IFNULL(QT_TUR_EJA_FUND, 0) AS qt_tur_eja_fundamental
FROM `rj-sme-dev.censoescolar.turmas_2025`
WHERE CO_MUNICIPIO = 3304557
  AND TP_DEPENDENCIA = 3;

CREATE OR REPLACE TABLE `rj-sme-dev.censoescolar_silver.docente` AS
SELECT
  NU_ANO_CENSO AS ano,
  CO_ENTIDADE  AS id_escola,
  IFNULL(QT_DOC_BAS, 0) AS qt_docentes,
  IFNULL(QT_DOC_BAS_ESCO_SUP_GRAD, 0) AS qt_docentes_superior
FROM `rj-sme-dev.censoescolar.docente_2025`
WHERE CO_MUNICIPIO = 3304557
  AND TP_DEPENDENCIA = 3;

CREATE OR REPLACE TABLE `rj-sme-dev.censoescolar_silver.gestor` AS
SELECT
  NU_ANO_CENSO AS ano,
  CO_ENTIDADE  AS id_escola,
  IFNULL(QT_GEST_BAS, 0) AS qt_gestores,
  IFNULL(QT_GEST_BAS_DIRETOR, 0) AS qt_diretores,
  IFNULL(QT_GEST_BAS_ACESSO_CARGO_CONC, 0) AS qt_gestores_concursados
FROM `rj-sme-dev.censoescolar.gestor_2025`
WHERE CO_MUNICIPIO = 3304557
  AND TP_DEPENDENCIA = 3;

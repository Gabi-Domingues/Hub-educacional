-- =====================================================================
-- 07 | TAXA DE ABANDONO — REDE MUNICIPAL DO RIO DE JANEIRO
-- Fonte: Base dos Dados — br_inep_indicadores_educacionais.municipio
-- (Indicadores Educacionais do INEP, taxas de rendimento), 2006–2024.
-- A taxa de abandono não consta dos microdados do Censo Escolar: é
-- calculada pelo INEP a partir da situação do aluno ao final do ano.
-- =====================================================================

-- 7.0 Conferência dos códigos de rede e localização (rodar antes)
SELECT rede, localizacao, COUNT(*) AS linhas
FROM `basedosdados.br_inep_indicadores_educacionais.municipio`
WHERE id_municipio = '3304557' AND ano = 2024
GROUP BY 1, 2
ORDER BY 1, 2;

-- 7.1 Série da taxa de abandono no ensino fundamental (%), 2015–2024
SELECT
  ano,
  taxa_abandono_ef,
  taxa_abandono_ef_anos_iniciais,
  taxa_abandono_ef_anos_finais
FROM `basedosdados.br_inep_indicadores_educacionais.municipio`
WHERE id_municipio = '3304557'
  AND LOWER(rede) = 'municipal'
  AND LOWER(localizacao) = 'total'
  AND ano BETWEEN 2015 AND 2024
ORDER BY ano;

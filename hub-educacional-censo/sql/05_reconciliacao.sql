-- =====================================================================
-- 05 | RECONCILIAÇÃO BRONZE → SILVER → GOLD
-- Os totais devem coincidir entre as camadas (critério "Reconciliação"
-- do Quadro 1.1 da monografia).
-- =====================================================================
SELECT 'bronze (rede municipal)' AS camada, SUM(QT_MAT_BAS) AS total_matriculas
FROM `rj-sme-dev.censoescolar.matricula_2025`
WHERE CO_MUNICIPIO = 3304557 AND TP_DEPENDENCIA = 3
UNION ALL
SELECT 'silver', SUM(qt_mat_basica) FROM `rj-sme-dev.censoescolar_silver.matricula`
UNION ALL
SELECT 'gold (fato_escola)', SUM(qt_mat_basica) FROM `rj-sme-dev.censoescolar_gold.fato_escola`
UNION ALL
-- a soma por etapa cobre apenas as 5 etapas ofertadas no painel; a diferença
-- para o total corresponde a outras modalidades (ex.: EJA médio, se houver)
SELECT 'gold (fato_matricula, 5 etapas)', SUM(qt_matriculas) FROM `rj-sme-dev.censoescolar_gold.fato_matricula`;

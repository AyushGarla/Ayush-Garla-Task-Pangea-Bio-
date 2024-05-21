select distinct on (use_subcategory_name) compound_name,pubchem_cid,use_category_name,use_subcategory_name,species_name from (
SELECT distinct use_category_name, use_subcategory_name,compound_name,pubchem_cid,species_name,uses
FROM (
    SELECT DISTINCT on(use_subcategory) ut.id,
        use_subcategory,use_category,species,uct.name AS use_category_name,ust.name AS use_subcategory_name,sft.name as species_name,notes as uses FROM naeb_uses_table ut
    LEFT JOIN (
        SELECT id, name FROM naeb_use_categories_table
    ) uct ON ut.use_category = uct.id
    LEFT JOIN (
        SELECT id, name FROM naeb_use_subcategories_table
	where name is not null
    ) ust ON 
        ut.use_subcategory = ust.id
	left join (select id,name from naeb_species_fam_table) sft
	on ut.species = sft.id
) pp
left join (select distinct compound_name,pubchem_cid,chembl_id from (
	SELECT np_id,LOWER(pref_name) AS compound_name,pubchem_cid,chembl_id,if_has_quantity FROM npass_compound_table)oq
	where chembl_id <>'Missing' and pubchem_cid <> 'Missing' and if_has_quantity =1)nct
	on EXISTS ( SELECT 1 FROM generate_series(1, length(pp.uses) - 3) AS i
        WHERE nct.compound_name LIKE '%' || SUBSTRING(pp.uses FROM i FOR 4) || '%'
    )
OR
EXISTS (SELECT 1
        FROM generate_series(1, length(nct.compound_name) - 3) AS j
        WHERE pp.uses LIKE '%' || SUBSTRING(nct.compound_name FROM j FOR 4) || '%'
    )
where use_subcategory_name is not null
	)oa
-- CREATE NEW MONTHLY DATA (RUNS FASTER THAN TENDERS VIEW)

drop table ocds.ccs_monthly;
create table ocds.ccs_monthly as
    (select * from ocds.ocds_tenders_view
        where releasedate >= '2020-01-01');

-- TENDER

select sub.*,
       CASE WHEN level1_col = 'Central Government' and sum_value::numeric >= '10000' THEN 'Y'
            WHEN (level1_col in ('Local Government', 'NHS') or level1_col is null) and sum_value::numeric >= '25000' THEN 'Y'
            WHEN level1_col in ('Local Government', 'NHS', 'Central Government') and (sum_value is null or sum_value::numeric = '0') THEN 'Y'
        ELSE 'N'
        END as value_included from (select t.ocid,
       t.source,
       ds.eprocurement_system,
       t.releasedate,
       t.enddate,
       t.buyer as buyer_original_name,
       em.entity_name as buyer_matched_name,
       em.entity_id as buyer_matched_id,
       em.level1 as level1_col,
       e.level2 as level2_col,
       t.value as sum_value,
       t.title,
       t.description,
       t.cpvs[1] as cpv_code_main,
       cpv1.en as cpv_description_main,
       t.cpvs[2] as cpv_code_2,
       cpv2.en as cpv_description_2,
       t.cpvs[3] as cpv_code_3,
       cpv3.en as cpv_description_3,
       t.cpvs[4] as cpv_code_4,
       cpv4.en as cpv_description_4,
       t.cpvs[5] as cpv_code_5,
       cpv5.en as cpv_description_5,
       t.contactname,
       t.email as contact_email,
       t.telephone as contact_phone,
       coalesce(t.json -> 'releases' -> 0 -> 'buyer' -> 'address' ->> 'locality', e.addr_post_town) as address_locality,
       coalesce(t.json -> 'releases' -> 0 -> 'buyer' -> 'address' ->> 'postalCode', e.addr_postcode) as address_postalcode,
       coalesce(t.json -> 'releases' -> 0 -> 'buyer' -> 'address' ->> 'countryName', addr_country) as address_countryname,
       coalesce(t.json -> 'releases' -> 0 -> 'buyer' -> 'address' ->> 'streetAddress', e.addr_line1) as address_streetaddress,
       t.tender_url as url,
       CASE when (cpvs[1] not in ('75122000', '45111310', '45216200')
            and cpvs[1] not like '85%'
            and cpvs [1] not like '3512%'
            and cpvs[1] not like '85%'
            and cpvs [1] not like '3533%'
            and cpvs[1] not like '3534%'
            and cpvs [1] not like '354%'
            and cpvs[1] not like '355%'
            and cpvs [1] not like '356%'
            and cpvs[1] not like '357%')
            or cpvs[1] is null then 'Y'
            ELSE 'N' END as cpv_included,
       CASE when t.source in ('td_competefor', 'td_exportingisgreat_int',
                 'td_lancashire_gov_uk', 'td_mod_uk', 'td_salfordcvs_uk',
                 'td_staffsmoorlands_gov_uk', 'td_stoke_gov_uk', 'td_ukho_delta_uk',
                 'td_westnorfolk_gov_uk', 'ted_notices', 'td_finditinbirmingham_uk',
                 'td_supply4nwfire', 'td_mytenders_uk', 'td_eu_supply', 'cf_notices')
    or tender_url ilike '%ardencsu.bravosolution%'
    or tender_url ilike '%cmu.bravosolution%'
    or tender_url ilike '%commercialsolutions.bravosolution%'
    or tender_url ilike '%crossrail.bravosolution%'
    or tender_url ilike '%crowncommercialservice.bravosolution%'
    or tender_url ilike '%ardencsu.bravosolution%'
    or tender_url ilike '%defra.bravosolution%'
    or tender_url ilike '%dwp.bravosolution%'
    or tender_url ilike '%eprocurenhs.bravosolution%'
    or tender_url ilike '%etendering.bravosolution%'
    or tender_url ilike '%fco.bravosolution%'
    or tender_url ilike '%food.bravosolution%'
    or tender_url ilike '%nhs.bravosolution%'
    or tender_url ilike '%ho.bravosolution%'
    or tender_url ilike '%hs2.bravosolution%'
    or tender_url ilike '%lbbd.bravosolution%'
    or tender_url ilike '%londonambulance.bravosolution%'
    or tender_url ilike '%ministryofjusticecommercial.bravosolution%'
    or tender_url ilike '%mlcsu.bravosolution%'
    or tender_url ilike '%networkrail.bravosolution%'
    or tender_url ilike '%nhsbsa.bravosolution%'
    or tender_url ilike '%nhsbt.bravosolution%'
    or tender_url ilike '%nhsengland.bravosolution%'
    or tender_url ilike '%nhsp.bravosolution%'
    or tender_url ilike '%nhspropertyservices.bravosolution%'
    or tender_url ilike '%ofcom.bravosolution%'
    or tender_url ilike '%ofgem.bravosolution%'
    or tender_url ilike '%orr.bravosolution%'
    or tender_url ilike '%phe.bravosolution%'
    or tender_url ilike '%resource.bravosolution%'
    or tender_url ilike '%royalmint.bravosolution%'
    or tender_url ilike '%biglottryfund.org%'
    or tender_url ilike '%sportengland.bravosolution%'
    or tender_url ilike '%westsussex.bravosolution%'
    or tender_url ilike '%eoecph.bravosolution%'
    or tender_url ilike '%legalaid.bravosolution%'
    or tender_url ilike '%thepensionsregulator.bravosolution%'
    or tender_url ilike '%whs.bravosolution%'
    or tender_url ilike '%sfo.bravosolution%'
    or tender_url ilike '%capitalresourcing.com%'
    or tender_url ilike '%public.bravosolution%'
    or tender_url ilike '%nhssurcing.co%'
    or tender_url ilike '%supplysouthampton.esourcingportal%'
    or tender_url ilike '%barnetsourcing.co%'
    or tender_url ilike '%tendhost.co.uk/adur-worthing%'
    or tender_url ilike '%tendhost.co.uk/advatagewm%'
    or tender_url ilike '%tendhost.co.uk/bedford%'
    or tender_url ilike '%tendhost.co.uk/birminghamcc%'
    or tender_url ilike '%tendhost.co.uk/blackcountryportal%'
    or tender_url ilike '%tendhost.co.uk/breckland%'
    or tender_url ilike '%tendhost.co.uk/centralbedfordshire%'
    or tender_url ilike '%tendhost.co.uk/chp%'
    or tender_url ilike '%tendhost.co.uk/cityofedinburghcouncil%'
    or tender_url ilike '%tendhost.co.uk/celevelandfire%'
    or tender_url ilike '%tendhost.co.uk/hampshire%'
    or tender_url ilike '%tendhost.co.uk/necs%'
    or tender_url ilike '%tendhost.co.uk/norfolkcc%'
    or tender_url ilike '%tendhost.co.uk/norwich%'
    or tender_url ilike '%tendhost.co.uk/portsmouthcc%'
    or tender_url ilike '%tendhost.co.uk/readingbc%'
    or tender_url ilike '%tendhost.co.uk/sadwellmbc%'
    or tender_url ilike '%tendhost.co.uk/scwcsu%'
    or tender_url ilike '%tendhost.co.uk/soepscomissioning%'
    or tender_url ilike '%tendhost.co.uk/soepsprovider%'
    or tender_url ilike '%tendhost.co.uk/tamworthbc%'
    or tender_url ilike '%tendhost.co.uk/walsallcouncil%'
    or tender_url ilike '%tendhost.co.uk/westyorkshireca%'
    or tender_url ilike '%tendhost.co.uk/worcestershire%'
    or tender_url ilike '%northumberland.gov%'
    or tender_url ilike '%814064bf%'
    or tender_url ilike '%1a2530c9%'
    or tender_url ilike '%40bb618e%'
    or tender_url ilike '%5171477e%'
    or tender_url ilike '%edea52dc%'
    or tender_url ilike '%afd36026%'
    or tender_url ilike '%10801f20%'
    or tender_url ilike '%1bc74770%'
    or tender_url ilike '%cdcfff6b%'
    or tender_url ilike '%679bb2ba%'
    or tender_url ilike '%ad706dc1%'
    or tender_url ilike '%08c1102f%'
    or tender_url ilike '%7a6b6917%'
    or tender_url ilike '%c8bf4a67%'
    or tender_url ilike '%c1cca830%'
    or tender_url ilike '%d45721ae%'
    or tender_url ilike '%deb5637a%'
    or tender_url ilike '%6a9b6d7b%'
    or tender_url ilike '%527b4bbd%'
    or tender_url ilike '%c71c7101%'
    or tender_url ilike '%1124fc0b%'
    or tender_url ilike '%45e01f71%'
    or tender_url ilike '%5e21c99e%'
    or tender_url ilike '%8b355dc0%'
    or tender_url ilike '%cca2f054%'
    or tender_url ilike '%procurement.luton%'
    or tender_url ilike '%procurement.southend%'
    or tender_url ilike '%45e01f71%'
    or tender_url ilike '%advantageswtenders%'
    or tender_url ilike '%bankofenglandtenders%'
    or tender_url ilike '%eastmidstenders%'
    or tender_url ilike '%5e21c99e%'
    or tender_url ilike '%lgssprocurementportal%'
    or tender_url ilike '%lppsourcing.org%'
    or tender_url ilike '%nepo.org%'
    or tender_url ilike '%supplybucksbusiness.org%'
    or tender_url ilike '%neupc.delta-neupc.delta%'
    or tender_url ilike '%sourcenottinghamshire.co%'
    or tender_url ilike '%sourcelincolnshire.co%'
    or tender_url ilike '%sourceleicestershire.co%'
    or tender_url ilike '%sourceeastmidlands.co%'
    or tender_url ilike '%sourcerutland.co%'
    or tender_url ilike '%sourcenorthamptonshire.co%'
    or tender_url ilike '%sourcederbyshire.co%'
    or tender_url ilike '%yortender.co%'
    or tender_url ilike '%the-chest.org%'
    or tender_url ilike '%supplyingthesouthwest.org%'
    or tender_url ilike '%eastmidstenders.org%'
    or tender_url ilike '%londontenders.org%'
    or tender_url ilike '%527b4bbd%'
    or tender_url ilike '%sebp.due-north%'
    or tender_url ilike '%iewm-prep.bravosolution%'
    or tender_url ilike '%tendhost.co.uk/csw-jets%'
    or tender_url ilike '%tendhost.co.uk/blackcountryportal%'
    or tender_url ilike '%tendhost.co.uk/supplyhertfordshire%'
    or tender_url ilike '%tendhost.co.uk/epl%'
    or tender_url ilike '%tendhost.co.uk/suffolksourcing%'
    or tender_url ilike '%kentbusinessportal.org%'
    or tender_url ilike '%housingprocurement.com%'
    or tender_url ilike '%lupc.bravosolution%'
    or tender_url ilike '%capitalesourcing.com%' then 'Y'
    else 'N' END as source_included,
CASE WHEN ((em.level1 in('Central Government', 'NHS', 'Local Government') and (e.level2 not in ('SCOTTISH LOCAL GOVERNMENT','SCOTTISH PENSION SCHEME', 'WELSH LOCAL GOVERNMENT', 'NORTHERN IRELAND') and (buyer not ilike '%limited%'
and buyer not ilike '%ltd%')))
or buyer in ('The South Tees Hospitals NHS Foundation Trust',
'Bradford Metropolitan District Council',
'Durham County Council',
'Wiltshire Council',
'Shropshire Council',
'Henley Town Council',
'Cornwall Council',
'Leighton Linslade Town Council',
'Cambridgeshire District Councils',
'Gaydon Parish Council',
'Redditch Borough &amp; Bromsgrove District Councils',
'Shaftesbury Town Council',
'Breckland District Council and South Holland District Council',
'General Dental Council',
'South Northants Council',
'THE UNITED KINGDOM SPORTS COUNCIL',
'East Suffolk Council',
'Hemsworth Town Council',
'West Yorkshire Combined Authority',
'Langport Town Council',
'Warwickshire Police &amp; West Mercia Police Procurement &amp; Contracts Department',
'Bedford Borough Council',
'Nailsea Town Council',
'Royal Wootton Bassett Town Council',
'NHS SUPPLY CHAIN',
'SALFORD PRIORS PARISH COUNCIL',
'BLYTH TOWN COUNCIL',
'NHS South West - Acutes',
'Crediton Town Council',
'Chelmsford City Council Pest Control',
'Quorn Parish Council',
'NHS Shared Business Services Ltd (NHS SBS)',
'Great Missenden Parish Council',
'General Medical Council (GMC)',
'Powick Parish Council',
'Great &amp; Little Pumstead Parish Council',
'Trowbridge Town Council',
'Weaver Vale Housing Trust e-Tendering',
'Bude-Stratton Town Council',
'Patchway Town Council',
'Five Councils Partnership',
'Newquay Town Council',
'Broadstairs &amp; St. Peter&#039;s Town Council',
'Bembridge Parish Council',
'Steeple Claydon Parish Council',
'NHS Arden and Greater East Midlands Commissioning Support Unit',
'Croft Parish Council',
'Tees Valley Combined Authority',
'Peabody Trust',
'South West Police Procurement Department (SWPPD)',
'Thrapston Town Council',
'Pitstone Parish Council',
'Canvey Island Town Council',
'Bickleigh Parish Council',
'BLEWBURY PARISH COUNCIL',
'Fordingbridge Town Council',
'West Suffolk Council',
'West Midlands Combined Authority',
'NHS Supply Chain Operated by North of England Commercial Procurement Collabrative (NoECPC) (who are hosted by Leeds and York Partnership NHS Foundation Trust) acting on behalf of Supply Chain Coordination Ltd',
'Henley-on-Thames Town Council',
'Fleet Town Council',
'Association of North East Councils Ltd trading as NEPO (Central Purchasing Body)',
'Barnsley, Doncaster, Rotherham and Sheffield Combined Authority',
'Batteries Torches and Lighting ‚Äî NHS Supply Chain',
'Cambridgeshire and Peterborough Combined Authority',
'Dorset &amp; Wiltshire Fire and Rescue Authority',
'East Of England NHS Collaborative Hub',
'Joseph Roundtree Housing Trust',
'London and Quadrant Housing Trust',
'Metropolitan Housing Trust Limited and Thames Valley Housing Association Limited',
'Metropolitan Housing Trust Ltd and Thames Valley Housing Association Ltd',
'Metropolitan Thames Valley t/a Metropolitan Housing Trust Limited and Thames Valley Housing Association Limited and their subsidiaries',
'Metropolitan Thames Valley t/a Metropolitan Housing Trust Ltd and Thames Valley Housing Association Ltd and their subsidiaries',
'MOD, IMOC, Defence Equipment Sales Authority',
'NHS ARDEN AND GREATER EAST MIDLANDS',
'NHS Bexley and NHS Greenwich Clinical Commissioning Groups',
'NHS Digital',
'NHS East Kent CCG''s',
'NHS London Procurement Partnership',
'NHS Midlands and Lancashire Commissioning Support Unit',
'NHS Midlands and Lancashire CSU',
'NHS Midlands and Lancashire CSU on behalf of NHS North Staffordshire CCG and NHS Stoke on Trent CCG',
'NHS Midlands and Lancashire CSU on behalf of South Staffordshire CCGs',
'NHS NEW Devon CCG',
'NHS SBS',
'NHS Shared Business Services (SBS)',
'NHS SOUTH, CENTRAL AND WEST COMMISSIONING SUPPORT UNIT',
'NHS Supply Chain ‚Äì Hotel Services Operating as North of England Commercial Procurement Collabrative (NoECPC)',
'NHS Supply Chain ‚Äî Office Supplies and Solutions',
'NHS Supply Chain Operated by DHL Supply Chain Ltd acting as agent of Supply Chain Coordination Ltd (SCCL)',
'NHS Supply Chain Operated by Health Solutions Team Ltd acting as agent of Supply Chain Coordination Ltd (SCCL)',
'NHS Supply Chain: Food is operated by Foodbuy Europe Ltd , as agent, for and on behalf of Supply Chain Coordination Ltd (‚ÄòSCCL‚Äô)',
'NHS Supply Chain: Food is operated by Foodbuy Europe Ltd, as agent, for and on behalf of Supply Chain Coordination Ltd (‚ÄòSCCL‚Äô)',
'NHS Trust',
'Northern Health and Social Care Trust',
'Notting Hill Housing Trust',
'Office and Outdoor Furniture ‚Äî NHS Supply Chain',
'Raven Housing Trust Limited',
'Somerset House Trust (SHT)',
'South Eastern Health and Social Care Trust',
'South Yorkshire Pensions Authority',
'The Collaborative Procurement Partnership LLP acting on behalf of Supply Chain Coordination Ltd a Management Function of NHS Supply Chain',
'The Collaborative Procurement partnership LLP acting on behalf of Supply Chain Coordination Ltd, a Management Function of NHS Supply Chain',
'West London  NHS Trust',
'West Yorkshire Combined Authority''Barnsley, Doncaster, Rotherham and Sheffield Combined Authority',
'West Yorkshire Combined Authority'))
THEN 'Y'
ELSE 'N'
END as buyer_included,
CASE WHEN mcf.has_cf_duplicate = 'Yes' then 'Y'
else 'N' end as cf_duplicate,
sources as duplication_source_list
from  ocds.ccs_monthly t
left join uk_data.ccs_matches em on (t.buyer=em.src_name)
left join uk_data.entity e on em.entity_id=e.entity_id
left join ocds.cpv_codes cpv1 on t.cpvs[1]=cpv1.code
left join ocds.cpv_codes cpv2 on t.cpvs[2]=cpv2.code
left join ocds.cpv_codes cpv3 on t.cpvs[3]=cpv3.code
left join ocds.cpv_codes cpv4 on t.cpvs[4]=cpv4.code
left join ocds.cpv_codes cpv5 on t.cpvs[5]=cpv5.code
left join ocds.data_sources ds on ds.source=t.source
left join contracts_finder.missing_cf_tenders mcf on mcf.ocid = t.ocid
Where t.releasedate >= '2020-04-01'
and t.releasedate < '2020-05-01'
and t.countryname in ('UK','United Kingdom','England')
group by
       t.ocid,
       t.source,
       ds.eprocurement_system,
       t.releasedate,
       t.enddate,
       buyer_original_name,
       buyer_matched_name,
       buyer_matched_id,
       level1_col,
       t.title,
       t.description,
       cpv_code_main,
       cpv_description_main,
       cpv_code_2,
       cpv_description_2,
       cpv_code_3,
       cpv_description_3,
       cpv_code_4,
       cpv_description_4,
       cpv_code_5,
       cpv_description_5,
       t.contactname,
       t.email,
       t.telephone,
       address_locality,
       address_postalcode,
       address_countryname,
       address_streetaddress,
       tender_url,
       t.value,
       e.level2,
       cf_duplicate,
       duplication_source_list)
            sub;

-- CONTRACTS

select sub.*,
       CASE WHEN level1_col = 'Central Government' and sum_value:: numeric >= '10000' THEN 'Y'
            WHEN (level1_col in ('Local Government', 'NHS') or level1_col is null) and sum_value:: numeric >= '25000' THEN 'Y'
            WHEN level1_col in ('Local Government', 'NHS', 'Central Government') and (sum_value is null or sum_value:: numeric = '0') THEN 'Y'
        ELSE 'N'
        END as value_included from(
select a.ocid,
       a.source,
       ds.eprocurement_system,
       a.releasedate,
       aw_contractperiod_enddate,
       a.buyer as buyer_original_name,
       em.entity_name as buyer_matched_name,
       em.entity_id as buyer_matched_id,
       em.level1 as level1_col,
       e.level2 as level2,
       sum((aw_value::numeric)/aw_total_suppliers) as sum_value,
       a.title,
       a.description,
       a.cpvs[1] as cpv_code_main,
       cpv1.en as cpv_description_main,
       a.cpvs[2] as cpv_code_2,
       cpv2.en as cpv_description_2,
       a.cpvs[3] as cpv_code_3,
       cpv3.en as cpv_description_3,
       a.cpvs[4] as cpv_code_4,
       cpv4.en as cpv_description_4,
       a.cpvs[5] as cpv_code_5,
       cpv5.en as cpv_description_5,
       t.contactname,
       t.email as contact_email,
       t.telephone as contact_phone,
       coalesce(t.json -> 'releases' -> 0 -> 'buyer' -> 'address' ->> 'locality', e.addr_post_town) as address_locality,
       coalesce(t.json -> 'releases' -> 0 -> 'buyer' -> 'address' ->> 'postalCode', e.addr_postcode) as address_postalcode,
       coalesce(t.json -> 'releases' -> 0 -> 'buyer' -> 'address' ->> 'countryName', addr_country) as address_countryname,
       coalesce(t.json -> 'releases' -> 0 -> 'buyer' -> 'address' ->> 'streetAddress', e.addr_line1) as address_streetaddress,
       t.tender_url as url,
       Case when (a.cpvs[1] not in ('75122000', '45111310', '45216200')
    and a.cpvs[1] not like '85%'
    and a.cpvs [1] not like '3512%'
    and a.cpvs[1] not like '85%'
    and a.cpvs [1] not like '3533%'
    and a.cpvs[1] not like '3534%'
    and a.cpvs [1] not like '354%'
    and a.cpvs[1] not like '355%'
    and a.cpvs [1] not like '356%'
    and a.cpvs[1] not like '357%')
    or a.cpvs[1] is null then 'Y'
    ELSE 'N'
    End as cpv_included,
       Case when (t.source in ('ted_notices','cf_notices')
    or tender_url ilike '%ardencsu.bravosolution%'
    or tender_url ilike '%cmu.bravosolution%'
    or tender_url ilike '%commercialsolutions.bravosolution%'
    or tender_url ilike '%crossrail.bravosolution%'
    or tender_url ilike '%crowncommercialservice.bravosolution%'
    or tender_url ilike '%ardencsu.bravosolution%'
    or tender_url ilike '%defra.bravosolution%'
    or tender_url ilike '%dwp.bravosolution%'
    or tender_url ilike '%eprocurenhs.bravosolution%'
    or tender_url ilike '%etendering.bravosolution%'
    or tender_url ilike '%fco.bravosolution%'
    or tender_url ilike '%food.bravosolution%'
    or tender_url ilike '%nhs.bravosolution%'
    or tender_url ilike '%ho.bravosolution%'
    or tender_url ilike '%hs2.bravosolution%'
    or tender_url ilike '%lbbd.bravosolution%'
    or tender_url ilike '%londonambulance.bravosolution%'
    or tender_url ilike '%ministryofjusticecommercial.bravosolution%'
    or tender_url ilike '%mlcsu.bravosolution%'
    or tender_url ilike '%networkrail.bravosolution%'
    or tender_url ilike '%nhsbsa.bravosolution%'
    or tender_url ilike '%nhsbt.bravosolution%'
    or tender_url ilike '%nhsengland.bravosolution%'
    or tender_url ilike '%nhsp.bravosolution%'
    or tender_url ilike '%nhspropertyservices.bravosolution%'
    or tender_url ilike '%ofcom.bravosolution%'
    or tender_url ilike '%ofgem.bravosolution%'
    or tender_url ilike '%orr.bravosolution%'
    or tender_url ilike '%phe.bravosolution%'
    or tender_url ilike '%resource.bravosolution%'
    or tender_url ilike '%royalmint.bravosolution%'
    or tender_url ilike '%biglottryfund.org%'
    or tender_url ilike '%sportengland.bravosolution%'
    or tender_url ilike '%westsussex.bravosolution%'
    or tender_url ilike '%eoecph.bravosolution%'
    or tender_url ilike '%legalaid.bravosolution%'
    or tender_url ilike '%thepensionsregulator.bravosolution%'
    or tender_url ilike '%whs.bravosolution%'
    or tender_url ilike '%sfo.bravosolution%'
    or tender_url ilike '%capitalresourcing.com%'
    or tender_url ilike '%public.bravosolution%'
    or tender_url ilike '%nhssurcing.co%'
    or tender_url ilike '%supplysouthampton.esourcingportal%'
    or tender_url ilike '%barnetsourcing.co%'
    or tender_url ilike '%tendhost.co.uk/adur-worthing%'
    or tender_url ilike '%tendhost.co.uk/advatagewm%'
    or tender_url ilike '%tendhost.co.uk/bedford%'
    or tender_url ilike '%tendhost.co.uk/birminghamcc%'
    or tender_url ilike '%tendhost.co.uk/blackcountryportal%'
    or tender_url ilike '%tendhost.co.uk/breckland%'
    or tender_url ilike '%tendhost.co.uk/centralbedfordshire%'
    or tender_url ilike '%tendhost.co.uk/chp%'
    or tender_url ilike '%tendhost.co.uk/cityofedinburghcouncil%'
    or tender_url ilike '%tendhost.co.uk/celevelandfire%'
    or tender_url ilike '%tendhost.co.uk/hampshire%'
    or tender_url ilike '%tendhost.co.uk/necs%'
    or tender_url ilike '%tendhost.co.uk/norfolkcc%'
    or tender_url ilike '%tendhost.co.uk/norwich%'
    or tender_url ilike '%tendhost.co.uk/portsmouthcc%'
    or tender_url ilike '%tendhost.co.uk/readingbc%'
    or tender_url ilike '%tendhost.co.uk/sadwellmbc%'
    or tender_url ilike '%tendhost.co.uk/scwcsu%'
    or tender_url ilike '%tendhost.co.uk/soepscomissioning%'
    or tender_url ilike '%tendhost.co.uk/soepsprovider%'
    or tender_url ilike '%tendhost.co.uk/tamworthbc%'
    or tender_url ilike '%tendhost.co.uk/walsallcouncil%'
    or tender_url ilike '%tendhost.co.uk/westyorkshireca%'
    or tender_url ilike '%tendhost.co.uk/worcestershire%'
    or tender_url ilike '%northumberland.gov%'
    or tender_url ilike '%814064bf%'
    or tender_url ilike '%1a2530c9%'
    or tender_url ilike '%40bb618e%'
    or tender_url ilike '%5171477e%'
    or tender_url ilike '%edea52dc%'
    or tender_url ilike '%afd36026%'
    or tender_url ilike '%10801f20%'
    or tender_url ilike '%1bc74770%'
    or tender_url ilike '%cdcfff6b%'
    or tender_url ilike '%679bb2ba%'
    or tender_url ilike '%ad706dc1%'
    or tender_url ilike '%08c1102f%'
    or tender_url ilike '%7a6b6917%'
    or tender_url ilike '%c8bf4a67%'
    or tender_url ilike '%c1cca830%'
    or tender_url ilike '%d45721ae%'
    or tender_url ilike '%deb5637a%'
    or tender_url ilike '%6a9b6d7b%'
    or tender_url ilike '%527b4bbd%'
    or tender_url ilike '%c71c7101%'
    or tender_url ilike '%1124fc0b%'
    or tender_url ilike '%45e01f71%'
    or tender_url ilike '%5e21c99e%'
    or tender_url ilike '%8b355dc0%'
    or tender_url ilike '%cca2f054%'
    or tender_url ilike '%procurement.luton%'
    or tender_url ilike '%procurement.southend%'
    or tender_url ilike '%45e01f71%'
    or tender_url ilike '%advantageswtenders%'
    or tender_url ilike '%bankofenglandtenders%'
    or tender_url ilike '%eastmidstenders%'
    or tender_url ilike '%5e21c99e%'
    or tender_url ilike '%lgssprocurementportal%'
    or tender_url ilike '%lppsourcing.org%'
    or tender_url ilike '%nepo.org%'
    or tender_url ilike '%supplybucksbusiness.org%'
    or tender_url ilike '%neupc.delta-neupc.delta%'
    or tender_url ilike '%sourcenottinghamshire.co%'
    or tender_url ilike '%sourcelincolnshire.co%'
    or tender_url ilike '%sourceleicestershire.co%'
    or tender_url ilike '%sourceeastmidlands.co%'
    or tender_url ilike '%sourcerutland.co%'
    or tender_url ilike '%sourcenorthamptonshire.co%'
    or tender_url ilike '%sourcederbyshire.co%'
    or tender_url ilike '%yortender.co%'
    or tender_url ilike '%the-chest.org%'
    or tender_url ilike '%supplyingthesouthwest.org%'
    or tender_url ilike '%eastmidstenders.org%'
    or tender_url ilike '%londontenders.org%'
    or tender_url ilike '%527b4bbd%'
    or tender_url ilike '%sebp.due-north%'
    or tender_url ilike '%iewm-prep.bravosolution%'
    or tender_url ilike '%tendhost.co.uk/csw-jets%'
    or tender_url ilike '%tendhost.co.uk/blackcountryportal%'
    or tender_url ilike '%tendhost.co.uk/supplyhertfordshire%'
    or tender_url ilike '%tendhost.co.uk/epl%'
    or tender_url ilike '%tendhost.co.uk/suffolksourcing%'
    or tender_url ilike '%kentbusinessportal.org%'
    or tender_url ilike '%housingprocurement.com%'
    or tender_url ilike '%lupc.bravosolution%'
    or tender_url ilike '%capitalesourcing.com%') then 'Y'
           Else 'N' END as source_included,
    Case when ((em.level1 in('Central Government', 'NHS', 'Local Government') and (e.level2 not in ('SCOTTISH LOCAL GOVERNMENT','SCOTTISH PENSION SCHEME', 'WELSH LOCAL GOVERNMENT', 'NORTHERN IRELAND') and (a.buyer not ilike '%limited%'
and a.buyer not ilike '%ltd%')))
or a.buyer in ('Hertfordshire NHS Procurement',
'HULL UNIVERSITY TEACHING HOSPITALS NHS TRUST',
'London and Quadrant Housing Trust',
'Metropolitan Housing Trust Limited and Thames Valley Housing Association Limited',
'Metropolitan Housing Trust Ltd and Thames Valley Housing Association Ltd',
'NHS Arden and Greater East Midlands Commissioning Support Unit',
'NHS Digital',
'NHS East Kent CCG''s',
'NHS South West - Acutes',
'NHS Supply Chain: Food is operated by Foodbuy Europe Ltd , as agent, for and on behalf of Supply Chain Coordination Ltd (‚ÄòSCCL‚Äô)',
'NHS Supply Chain: Food is operated by Foodbuy Europe Ltd, as agent, for and on behalf of Supply Chain Coordination Ltd (‚ÄòSCCL‚Äô)',
'NHS Trust',
'Peabody Trust',
'Raven Housing Trust Limited',
'Somerset House Trust (SHT)',
'South Eastern Health and Social Care Trust',
'The Collaborative Procurement Partnership LLP acting on behalf of Supply Chain Coordination Ltd a Management Function of NHS Supply Chain',
'WEST MIDLANDS COMBINED AUTHORITY',
'West Yorkshire Combined Authority'
'The South Tees Hospitals NHS Foundation Trust',
'Bradford Metropolitan District Council',
'Durham County Council',
'Wiltshire Council',
'Shropshire Council',
'Henley Town Council',
'Cornwall Council',
'Leighton Linslade Town Council',
'Cambridgeshire District Councils',
'Gaydon Parish Council',
'Redditch Borough &amp; Bromsgrove District Councils',
'Shaftesbury Town Council',
'Breckland District Council and South Holland District Council',
'General Dental Council',
'South Northants Council',
'THE UNITED KINGDOM SPORTS COUNCIL',
'East Suffolk Council',
'Hemsworth Town Council',
'West Yorkshire Combined Authority',
'Langport Town Council',
'Warwickshire Police &amp; West Mercia Police Procurement &amp; Contracts Department',
'Bedford Borough Council',
'Nailsea Town Council',
'Royal Wootton Bassett Town Council',
'NHS SUPPLY CHAIN',
'SALFORD PRIORS PARISH COUNCIL',
'BLYTH TOWN COUNCIL',
'Crediton Town Council',
'Chelmsford City Council Pest Control',
'Quorn Parish Council',
'NHS Shared Business Services Ltd (NHS SBS)',
'Great Missenden Parish Council',
'General Medical Council (GMC)',
'Powick Parish Council',
'Great &amp; Little Pumstead Parish Council',
'Trowbridge Town Council',
'Weaver Vale Housing Trust e-Tendering',
'Bude-Stratton Town Council',
'Patchway Town Council',
'Five Councils Partnership',
'Newquay Town Council',
'Broadstairs &amp; St. Peter&#039;s Town Council',
'Bembridge Parish Council',
'Steeple Claydon Parish Council',
'Croft Parish Council',
'Tees Valley Combined Authority',
'South West Police Procurement Department (SWPPD)',
'Thrapston Town Council',
'Pitstone Parish Council',
'Canvey Island Town Council',
'Bickleigh Parish Council',
'BLEWBURY PARISH COUNCIL',
'Fordingbridge Town Council',
'West Suffolk Council',
'NHS Supply Chain Operated by North of England Commercial Procurement Collabrative (NoECPC) (who are hosted by Leeds and York Partnership NHS Foundation Trust) acting on behalf of Supply Chain Coordination Ltd',
'Henley-on-Thames Town Council',
'Fleet Town Council',
'Association of North East Councils Ltd trading as NEPO (Central Purchasing Body)',
'Barnsley, Doncaster, Rotherham and Sheffield Combined Authority',
'Batteries Torches and Lighting ‚Äî NHS Supply Chain',
'Cambridgeshire and Peterborough Combined Authority',
'Dorset &amp; Wiltshire Fire and Rescue Authority',
'East Of England NHS Collaborative Hub',
'Joseph Roundtree Housing Trust',
'Metropolitan Thames Valley t/a Metropolitan Housing Trust Limited and Thames Valley Housing Association Limited and their subsidiaries',
'Metropolitan Thames Valley t/a Metropolitan Housing Trust Ltd and Thames Valley Housing Association Ltd and their subsidiaries',
'MOD, IMOC, Defence Equipment Sales Authority',
'NHS ARDEN AND GREATER EAST MIDLANDS',
'NHS Bexley and NHS Greenwich Clinical Commissioning Groups',
'NHS London Procurement Partnership',
'NHS Midlands and Lancashire Commissioning Support Unit',
'NHS Midlands and Lancashire CSU',
'NHS Midlands and Lancashire CSU on behalf of NHS North Staffordshire CCG and NHS Stoke on Trent CCG',
'NHS Midlands and Lancashire CSU on behalf of South Staffordshire CCGs',
'NHS NEW Devon CCG',
'NHS SBS',
'NHS Shared Business Services (SBS)',
'NHS SOUTH, CENTRAL AND WEST COMMISSIONING SUPPORT UNIT',
'NHS Supply Chain ‚Äì Hotel Services Operating as North of England Commercial Procurement Collabrative (NoECPC)',
'NHS Supply Chain ‚Äî Office Supplies and Solutions',
'NHS Supply Chain Operated by DHL Supply Chain Ltd acting as agent of Supply Chain Coordination Ltd (SCCL)',
'NHS Supply Chain Operated by Health Solutions Team Ltd acting as agent of Supply Chain Coordination Ltd (SCCL)',
'Northern Health and Social Care Trust',
'Notting Hill Housing Trust',
'Office and Outdoor Furniture ‚Äî NHS Supply Chain',
'South Yorkshire Pensions Authority',
'The Collaborative Procurement partnership LLP acting on behalf of Supply Chain Coordination Ltd, a Management Function of NHS Supply Chain',
'West London  NHS Trust',
'West Yorkshire Combined Authority''Barnsley, Doncaster, Rotherham and Sheffield Combined Authority'))
THEN 'Y'
ELSE 'N'
END as buyer_included,
CASE WHEN mcf.has_cf_duplicate = 'Yes' then 'Y'
else 'N' end as cf_duplicate,
sources as duplication_source_list
from ocds.ocds_awards_suppliers_view_mat a
left join ocds.ccs_monthly t on a.ocid=t.ocid
left join uk_data.ccs_matches em on (a.buyer=em.src_name)
left join uk_data.entity e on em.entity_id=e.entity_id
left join ocds.cpv_codes cpv1 on a.cpvs[1]=cpv1.code
left join ocds.cpv_codes cpv2 on a.cpvs[2]=cpv2.code
left join ocds.cpv_codes cpv3 on a.cpvs[3]=cpv3.code
left join ocds.cpv_codes cpv4 on a.cpvs[4]=cpv4.code
left join ocds.cpv_codes cpv5 on a.cpvs[5]=cpv5.code
left join ocds.data_sources ds on ds.source=a.source
left join contracts_finder.missing_cf_awards mcf on mcf.ocid=a.ocid
Where a.releasedate >= '2020-04-01'
and a.releasedate < '2020-05-01'
and (a.countryname in ('UK','United Kingdom','England') or a.source=('cn_in_tend_uk'))
and a.source <> 'cn_millstream'
group by
       a.ocid,
       t.source,
       a.source,
       ds.eprocurement_system,
       a.releasedate,
       a.aw_contractperiod_enddate,
       buyer_original_name,
       buyer_matched_name,
       buyer_matched_id,
       level1_col,
       a.title,
       a.description,
       cpv_code_main,
       cpv_description_main,
       cpv_code_2,
       cpv_description_2,
       cpv_code_3,
       cpv_description_3,
       cpv_code_4,
       cpv_description_4,
       cpv_code_5,
       cpv_description_5,
       t.contactname,
       t.email,
       t.telephone,
       address_locality,
       address_postalcode,
       address_countryname,
       address_streetaddress,
       tender_url,
       e.level2,
       cf_duplicate,
       duplication_source_list) sub

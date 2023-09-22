permissionset 50124 PRSET50124CDSPostCod
{
    Assignable = true;
    Permissions = tabledata "CDS Country/Region" = RIMD,
        tabledata "CDS dmm_PostCode" = RIMD,
        tabledata "CRM  CFDI Export Code" = RIMD,
        tabledata "CRM Payment methods" = RIMD,
        tabledata "CRM SAT Tax Scheme" = RIMD,
        tabledata "CRM SAT Use Code" = RIMD,
        table "CDS Country/Region" = X,
        table "CDS dmm_PostCode" = X,
        table "CRM  CFDI Export Code" = X,
        table "CRM Payment methods" = X,
        table "CRM SAT Tax Scheme" = X,
        table "CRM SAT Use Code" = X,
        codeunit IntegrationFieldMapping = X,
        page " CRM Country Code List" = X,
        page " CRM Post Code List" = X,
        page "CRM CFDI Export List" = X,
        page "CRM Payment Method List" = X,
        page "CRM SAT Tax Scheme" = X,
        page "CRM SAT Use Code" = X;
}
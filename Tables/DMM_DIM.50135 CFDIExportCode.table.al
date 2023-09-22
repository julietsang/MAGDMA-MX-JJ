tableextension 50135 CFDIEXPORTCODEEXT extends "CFDI Export Code"
{

    fields
    {
        field(50000; "Coupled to CRM"; Boolean)
        {
            //FieldClass = FlowField;
            Editable = false;
            // CalcFormula = exist("CRM Integration Record" where("Integration ID" = field(SystemId), "Table ID" = const(Database::"Payment Method")));
            Caption = 'Coupled to Dataverse';

        }
    }
}
tableextension 50126 SalesLineEXT extends "Sales Line"
{

    fields
    {
        field(50100; "Your Reference"; Text[35])
        {
            Caption = 'Your Reference';


            FieldClass = FlowField;
            // Editable = FALSE;
            CalcFormula = lookup("Sales Header"."Your Reference" where("No." = field("Document No.")));

        }
    }
}
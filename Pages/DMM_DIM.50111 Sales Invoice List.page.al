#pragma implicitwith disable
pageextension 50111 "SalesInvListExt" extends "Sales Invoice List"
{
    layout
    {
        addafter("No.")
        {
            field("Your Reference40569"; Rec."Your Reference")
            {
                ApplicationArea = All;
            }
        }
    }
}
#pragma implicitwith restore

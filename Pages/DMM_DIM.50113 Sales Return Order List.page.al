#pragma implicitwith disable
pageextension 50113 "SalesReturnOrderListExt" extends "Sales Return Order List"

{
    layout
    {
        addafter("No.")
        {
            field("Your Reference"; Rec."Your Reference")
            {
                ApplicationArea = All;

            }
        }
    }
}
#pragma implicitwith restore

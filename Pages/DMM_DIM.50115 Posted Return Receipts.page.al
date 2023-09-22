#pragma implicitwith disable
pageextension 50115 "PostedSalesReturnRcptListExt" extends "Posted Return Receipts"

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

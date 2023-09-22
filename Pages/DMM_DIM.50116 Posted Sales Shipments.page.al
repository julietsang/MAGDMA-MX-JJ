#pragma implicitwith disable
pageextension 50116 "PostedSalesShipmentListExt" extends "Posted Sales Shipments"

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

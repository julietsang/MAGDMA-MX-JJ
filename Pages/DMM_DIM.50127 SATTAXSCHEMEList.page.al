#pragma implicitwith disable
pageextension 50127 "SATTAXSCHEMEEXT" extends "SAT Tax Schemas"
{
    layout
    {
        addafter(Description)
        {
            field("Coupled to CRM"; Rec."Coupled to CRM")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies that the payment term is coupled to a payment term in Dataverse.';
                Visible = CDSIntegrationEnabled;
            }
        }
    }
    actions
    {
        addlast(navigation)
        {
            group(ActionGroupCRM)
            {
                Caption = 'Dataverse';
                Image = Administration;
                Visible = CDSIntegrationEnabled;
                action(CRMSynchronizeNow)
                {
                    AccessByPermission = TableData "CRM Integration Record" = IM;
                    ApplicationArea = Suite;
                    Caption = 'Synchronize';
                    Image = Refresh;
                    ToolTip = 'Send or get updated data to or from Dataverse.';

                    trigger OnAction()
                    var
                        PaymentTerms: Record "SAT Tax Scheme";
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                        PaymentMethodRecordRef: RecordRef;
                    begin
                        CurrPage.SetSelectionFilter(PaymentTerms);
                        PaymentMethodRecordRef.GetTable(PaymentTerms);
                        CRMIntegrationManagement.UpdateMultipleNow(PaymentMethodRecordRef, true);
                    end;
                }
                group(Coupling)
                {
                    Caption = 'Coupling', Comment = 'Coupling is a noun';
                    Image = LinkAccount;
                    ToolTip = 'Create, change, or delete a coupling between the Business Central record and a Dataverse record.';
                    action(ManageCRMCoupling)
                    {
                        AccessByPermission = TableData "CRM Integration Record" = IM;
                        ApplicationArea = Suite;
                        Caption = 'Set Up Coupling';
                        Image = LinkAccount;
                        ToolTip = 'Create or modify the coupling to a Dataverse Payment Terms.';

                        trigger OnAction()
                        var
                            CRMIntegrationManagement: Codeunit "CRM Integration Management";

                        begin
                            CRMIntegrationManagement.DefineOptionMapping(Rec.RecordId);

                            CRMOptionMapping.reset;
                            CRMOptionMapping.SetRange("Table ID", Database::"SAT Tax Scheme");
                            if CRMOptionMapping.Find('-') then
                                repeat

                                    Rec."Coupled to CRM" := true;
                                until CRMOptionMapping.Next() = 0;


                        end;
                    }
                    action(MatchBasedCoupling)
                    {
                        AccessByPermission = TableData "CRM Integration Record" = IM;
                        ApplicationArea = Suite;
                        Caption = 'Match-Based Coupling';
                        Image = CoupledUnitOfMeasure;
                        ToolTip = 'Couple payment terms in Dataverse based on criteria.';

                        trigger OnAction()
                        var
                            PaymentTerms: Record "Payment Terms";
                            CRMIntegrationManagement: Codeunit "CRM Integration Management";
                            RecRef: RecordRef;
                        begin
                            CurrPage.SetSelectionFilter(PaymentTerms);
                            RecRef.GetTable(PaymentTerms);
                            // CRMIntegrationManagement.MatchBasedCoupling(RecRef);
                        end;
                    }
                    action(DeleteCRMCoupling)
                    {
                        AccessByPermission = TableData "CRM Integration Record" = D;
                        ApplicationArea = Suite;
                        Caption = 'Delete Coupling';
                        Enabled = CDSIsCoupledToRecord;
                        Image = UnLinkAccount;
                        ToolTip = 'Delete the coupling to a Dataverse Payment Terms.';

                        trigger OnAction()
                        var
                            PaymentTerms: Record "SAT Tax Scheme";
                            CRMIntegrationManagement: Codeunit "CRM Integration Management";
                            RecRef: RecordRef;
                        begin
                            CRMOptionMapping.reset;
                            CRMOptionMapping.SetRange("Table ID", Database::"SAT Tax Scheme");
                            if CRMOptionMapping.Find('-') then
                                repeat
                                    Rec."Coupled to CRM" := false;
                                // Rec.Modify();
                                until CRMOptionMapping.Next() = 0;
                            CurrPage.SetSelectionFilter(PaymentTerms);
                            RecRef.GetTable(PaymentTerms);
                            CRMIntegrationManagement.RemoveOptionMapping(RecRef);

                            CRMOptionMapping.reset;
                            CRMOptionMapping.SetRange("Table ID", Database::"SAT Tax Scheme");
                            if CRMOptionMapping.Find('-') then
                                repeat
                                    Rec."Coupled to CRM" := false;
                                // Rec.Modify();
                                until CRMOptionMapping.Next() = 0;

                        end;
                    }
                }
                action(ShowLog)
                {
                    ApplicationArea = Suite;
                    Caption = 'Synchronization Log';
                    Image = Log;
                    ToolTip = 'View integration synchronization jobs for the payment terms table.';

                    trigger OnAction()
                    var
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    begin
                        CRMIntegrationManagement.ShowOptionLog(Rec.RecordId);
                    end;
                }
            }
        }
    }


    trigger OnOpenPage()
    var
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
    begin
        CDSIntegrationEnabled := CRMIntegrationManagement.IsCDSIntegrationEnabled()
        // and CRMIntegrationManagement.IsOptionMappingEnabled();
    end;

    trigger OnAfterGetCurrRecord()
    var
        CRMOptionMapping: Record "CRM Option Mapping";
    begin
        CDSIsCoupledToRecord := CDSIntegrationEnabled;
        if CDSIsCoupledToRecord then begin
            CRMOptionMapping.SetRange("Record ID", Rec.RecordId);
            CDSIsCoupledToRecord := not CRMOptionMapping.IsEmpty();
        end;
    end;





    var
        CDSIntegrationEnabled: Boolean;
        CDSIsCoupledToRecord: Boolean;

    var
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
        CRMCouplingManagement: Codeunit "CRM Coupling Management";
        DataverseIntegrationEnabled: Boolean;
        DataverseIsCoupledToRecord: Boolean;
        IntegrationFieldMapping: Codeunit IntegrationFieldMapping;
        CRMOptionMapping: Record "CRM Option Mapping";

}
#pragma implicitwith restore

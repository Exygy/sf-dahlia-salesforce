<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata"><fieldUpdates>
        <fullName>UpdatePOBoxFieldFalse</fullName>
        <field>Accepting_applications_by_PO_Box__c</field>
        <literalValue>0</literalValue>
        <name>UpdatePOBoxFieldFalse</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates><fieldUpdates>
        <fullName>UpdateSASEfieldFALSE</fullName>
        <field>SASE_Required_for_Lottery_Ticket__c</field>
        <literalValue>0</literalValue>
        <name>UpdateSASEfieldFALSE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates><fieldUpdates>
        <fullName>UpdateSASEfieldTRUE</fullName>
        <field>SASE_Required_for_Lottery_Ticket__c</field>
        <literalValue>1</literalValue>
        <name>UpdateSASEfieldTRUE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates><fieldUpdates>
        <fullName>Flagged_Applications</fullName>
        <field>nFlagged_Applications__c</field>
        <formula>IF( ISNULL(nFlagged_Applications__c) , 0, nFlagged_Applications__c)</formula>
        <name>Flagged Applications</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>General_Applications_Total</fullName>
        <field>nGeneral_Application_Total__c</field>
        <formula>IF( ISNULL(nGeneral_Application_Total__c) , 0, nGeneral_Application_Total__c)</formula>
        <name>General Applications Total</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>Removed_From_Lottery</fullName>
        <field>nRemoved_from_Lottery__c</field>
        <formula>IF( ISNULL(nRemoved_from_Lottery__c) , 0, nRemoved_from_Lottery__c)</formula>
        <name>Removed From Lottery</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>Submitted_Applications</fullName>
        <field>nSubmitted_Applications__c</field>
        <formula>IF( ISNULL(nSubmitted_Applications__c) , 0, nSubmitted_Applications__c)</formula>
        <name>Submitted Applications</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>Total_Application</fullName>
        <description>Set Total Application to 0</description>
        <field>nTotal_Applications__c</field>
        <formula>IF( ISNULL(nTotal_Applications__c ) , 0, nTotal_Applications__c )</formula>
        <name>Total Application</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates><rules>
        <fullName>IFAcceptingApplicationsByPOBox</fullName>
        <actions>
            <name>UpdateSASEfieldTRUE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Listing__c.Accepting_applications_by_PO_Box__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Listing__c.SASE_Required_for_Lottery_Ticket__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>If Accepting applications by PO Box TRUE then Update SASE_Required_for_Lottery_Ticket__c to TRUE</description>
        <triggerType>onAllChanges</triggerType>
    </rules><rules>
        <fullName>IFNotAcceptingApplicationsByPOBox</fullName>
        <actions>
            <name>UpdateSASEfieldFALSE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2)</booleanFilter>
        <criteriaItems>
            <field>Listing__c.Accepting_applications_by_PO_Box__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Listing__c.SASE_Required_for_Lottery_Ticket__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>If Accepting applications by PO Box FALSE then Update SASE_Required_for_Lottery_Ticket__c to FALSE</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules><rules>
        <fullName>IFNotSASERequired</fullName>
        <actions>
            <name>UpdatePOBoxFieldFalse</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UpdateSASEfieldFALSE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Listing__c.SASE_Required_for_Lottery_Ticket__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>If Accepting applications by PO Box FALSE then Update SASE_Required_for_Lottery_Ticket__c to FALSE</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules><rules>
        <fullName>Treat blanks as zero</fullName>
        <actions>
            <name>Flagged_Applications</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>General_Applications_Total</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Removed_From_Lottery</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Submitted_Applications</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Total_Application</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(LastModifiedDate)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules></Workflow>

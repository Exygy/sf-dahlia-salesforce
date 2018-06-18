<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata"><alerts>
        <fullName>COP_Final_Review_Reminder</fullName>
        <description>COP: Final Review Reminder</description>
        <protected>false</protected>
        <recipients>
            <recipient>maria.benjamin@sfgov.org</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>COP_Email_Templates/COP_Initial_Review_Reminder</template>
    </alerts><alerts>
        <fullName>COP_Initial_Review_Reminder</fullName>
        <description>COP: Initial Review Reminder</description>
        <protected>false</protected>
        <recipients>
            <recipient>sonia.delgado-schaumberg@sfgov.org</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>COP_Email_Templates/COP_Initial_Review_Reminder</template>
    </alerts><alerts>
        <fullName>COP_Manager_Rejected</fullName>
        <description>COP: Manager Rejected</description>
        <protected>false</protected>
        <recipients>
            <recipient>sonia.mcdaniel@sfgov.org</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>COP_Email_Templates/COP_Reviewer_Sent_Back</template>
    </alerts><alerts>
        <fullName>COP_Notify_Final_Reviewer</fullName>
        <description>COP: Notify Final Reviewer</description>
        <protected>false</protected>
        <recipients>
            <recipient>maria.benjamin@sfgov.org</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>COP_Email_Templates/COP_Ready_for_Final_Review</template>
    </alerts><alerts>
        <fullName>COP_Record_is_Ready_for_Initial_Manager_Review</fullName>
        <description>COP: Record is Ready for Initial Manager Review</description>
        <protected>false</protected>
        <recipients>
            <recipient>sonia.delgado-schaumberg@sfgov.org</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>COP_Email_Templates/COP_Ready_for_Initial_Review</template>
    </alerts><alerts>
        <fullName>COP_Reviewed_and_Fully_Approved</fullName>
        <description>COP: Reviewed and Fully Approved</description>
        <protected>false</protected>
        <recipients>
            <recipient>sonia.mcdaniel@sfgov.org</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>COP_Email_Templates/COP_Approval_Complete</template>
    </alerts><fieldUpdates>
        <fullName>Copy_Current_St_No_to_Mailing_St_No</fullName>
        <field>COP_Applicant_Mailing_Address_St_Number__c</field>
        <formula>COP_Applicant_Current_Address_St_Number__c</formula>
        <name>Copy Current St No to Mailing St No</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates><fieldUpdates>
        <fullName>Current_City_to_Mailing_City</fullName>
        <field>COP_Applicant_Mailing_Address_City__c</field>
        <formula>COP_Applicant_Current_Address_City__c</formula>
        <name>Current City to Mailing City</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates><fieldUpdates>
        <fullName>Current_St_Name_to_Mailing_St_Name</fullName>
        <field>COP_Applicant_Mailing_Address_St_Name__c</field>
        <formula>COP_Applicant_Current_Address_St_Name__c</formula>
        <name>Current St Name to Mailing St Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates><fieldUpdates>
        <fullName>Current_St_Type_to_Mailing_St_Type</fullName>
        <field>COP_Applicant_Mailing_Address_St_Type__c</field>
        <name>Current St Type to Mailing St Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates><fieldUpdates>
        <fullName>Current_State_to_Mailing_State</fullName>
        <field>COP_Applicant_Mailing_Address_State__c</field>
        <name>Current State to Mailing State</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates><fieldUpdates>
        <fullName>Current_Unit_No_to_Mailing_Unit_No</fullName>
        <field>COP_Applicant_Mailing_Address_Unit_Num__c</field>
        <formula>COP_Applicant_Current_Address_Unit_Num__c</formula>
        <name>Current Unit No to Mailing Unit No</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates><fieldUpdates>
        <fullName>Current_Zip_to_Mailing_Zip</fullName>
        <field>COP_Applicant_Mailing_Address_Zipcode__c</field>
        <formula>COP_Applicant_Current_Address_Zipcode__c</formula>
        <name>Current Zip to Mailing Zip</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates><fieldUpdates>
        <fullName>Update_Mgr_Status_to_Final_Approve</fullName>
        <field>Manager_Review_Status__c</field>
        <literalValue>Final_Review_Approved</literalValue>
        <name>Update Mgr Status to Final Approve</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>Update_Mgr_Status_to_Initial_Approve</fullName>
        <field>Manager_Review_Status__c</field>
        <literalValue>Initial_Review_Approved</literalValue>
        <name>Update Mgr Status to Initial Approve</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>Update_Mgr_Status_to_None</fullName>
        <field>Manager_Review_Status__c</field>
        <name>Update Mgr Status to None</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>Update_Mgr_Status_to_Pending_Inital_Rev</fullName>
        <field>Manager_Review_Status__c</field>
        <literalValue>Pending Initial Review</literalValue>
        <name>Update Mgr Status to Pending Inital Rev</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>Update_Mgr_Status_to_Send_Back</fullName>
        <field>Manager_Review_Status__c</field>
        <literalValue>Rejected/Sent Back</literalValue>
        <name>Update Mgr Status to Send Back</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates></Workflow>
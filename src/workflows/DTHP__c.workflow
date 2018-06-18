<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata"><alerts>
        <fullName>DTHP_Final_Review_Status_Updated_Approved</fullName>
        <description>DTHP Final Review Status Updated - Approved</description>
        <protected>false</protected>
        <recipients>
            <recipient>melissa.cardoza@sfgov.org</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DTHP_Email_Templates/DTHP_Status_Email_Template</template>
    </alerts><alerts>
        <fullName>DTHP_Final_Review_Status_Updated_Rejected</fullName>
        <description>DTHP Final Review Status Updated - Rejected</description>
        <protected>false</protected>
        <recipients>
            <recipient>melissa.cardoza@sfgov.org</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DTHP_Email_Templates/DTHP_Status_Email_Template</template>
    </alerts><alerts>
        <fullName>DTHP_Pending_Final_Approval_Email_Alert</fullName>
        <description>DTHP Pending Final Approval Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>melissa.cardoza@sfgov.org</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DTHP_Email_Templates/DTHP_Pending_Final_Approval_Email_Template</template>
    </alerts><fieldUpdates>
        <fullName>DTHP_Application_Approved</fullName>
        <field>DTHP_Application_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>DTHP Application Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>DTHP_Application_Not_Approved</fullName>
        <field>DTHP_Application_Status__c</field>
        <literalValue>Not Approved</literalValue>
        <name>DTHP Application Not Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>DTHP_Application_Recall</fullName>
        <field>DTHP_Application_Status__c</field>
        <literalValue>Recalled</literalValue>
        <name>DTHP Application Recall</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>DTHP_Approved</fullName>
        <field>DTHP_Application_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>DTHP Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>DTHP_Not_Approved</fullName>
        <description>Applications that were sent to supervisor approval but was rejected.</description>
        <field>DTHP_Application_Status__c</field>
        <literalValue>Not Approved</literalValue>
        <name>DTHP Not Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>Submit_Pending_Final_Approval</fullName>
        <field>DTHP_Application_Status__c</field>
        <literalValue>Pending Final Approval</literalValue>
        <name>Submit - Pending Final Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates></Workflow>
<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CONTACT_Copy_Household_Address</fullName>
        <field>Mailing_Address_same_as_Current_Address__c</field>
        <literalValue>0</literalValue>
        <name>CONTACT: Copy Household Address</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateMailingCity</fullName>
        <field>MailingCity</field>
        <formula>Account.BillingCity</formula>
        <name>UpdateMailingCity</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateMailingCountry</fullName>
        <field>MailingCountry</field>
        <formula>Account.BillingCountry</formula>
        <name>UpdateMailingCountry</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateMailingState</fullName>
        <field>MailingState</field>
        <formula>Account.BillingState</formula>
        <name>UpdateMailingState</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateMailingStreet</fullName>
        <field>MailingStreet</field>
        <formula>Account.BillingStreet</formula>
        <name>UpdateMailingStreet</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateMailingZip</fullName>
        <field>MailingPostalCode</field>
        <formula>Account.BillingPostalCode</formula>
        <name>UpdateMailingZip</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CopyBillingAddressToMailingAddress</fullName>
        <actions>
            <name>UpdateMailingCity</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UpdateMailingCountry</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UpdateMailingState</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UpdateMailingStreet</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UpdateMailingZip</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>equals</operation>
            <value>Property Agent</value>
        </criteriaItems>
        <description>Copy Billing Address To Mailing Address on Contact object</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
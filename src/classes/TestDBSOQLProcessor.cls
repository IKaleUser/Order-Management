@isTest
public with sharing class TestDBSOQLProcessor {
    @isTest
    public static void getConditionEqualPositiveTest() {
        String result = DBSOQLProcessor.getConditionEqual('Name', 'Igor');
        System.assertEquals('Name=\'Igor\'', result, 'getConditionEqual return wrong String');
    }

    @isTest
    public static void getConditionEqualEmptyValueTest() {
        String result = DBSOQLProcessor.getConditionEqual('Name', '');
        System.assertEquals('', result, 'getConditionEqual return not empty string');
    }

    @isTest
    public static void getConditionEqualNullValueTest() {
        String result = DBSOQLProcessor.getConditionEqual('Name', null);
        System.assertEquals('', result, 'getConditionEqual return not empty string');
    }

    @isTest
    public static void getConditionLikePositiveTest() {
        String result = DBSOQLProcessor.getConditionLike('Name', 'Igor');
        System.assertEquals('Name LIKE\'%Igor%\'', result, 'getConditionLike return wrong String');
    }

    @isTest
    public static void getConditionLikeEmptyValueTest() {
        String result = DBSOQLProcessor.getConditionLike('Name', '');
        System.assertEquals('', result, 'getConditionLike return not empty string');
    }

    @isTest
    public static void getConditionLikeNullValueTest() {
        String result = DBSOQLProcessor.getConditionLike('Name', null);
        System.assertEquals('', result, 'getConditionLike return not empty string');
    }

    @isTest
    public static void setConditionPositiveMoreThanOneConditionTest() {
        List<String> conditions = new List<String>{'condition1','condition2','condition3'};
        String result = DBSOQLProcessor.setCondition(conditions);
        System.assertEquals('WHERE condition1 AND condition2 AND condition3', result, 'setCondition return wrong String');
    }

    @isTest
    public static void setConditionPositiveOneConditionTest() {
        List<String> conditions = new List<String>{'condition1'};
        String result = DBSOQLProcessor.setCondition(conditions);
        System.assertEquals('WHERE condition1', result, 'setCondition return wrong String');
    }

    @isTest
    public static void setConditionPositiveAllConditionEmptyTest() {
        List<String> conditions = new List<String>{'' ,'' ,''};
        String result = DBSOQLProcessor.setCondition(conditions);
        System.assertEquals('', result, 'setCondition return not Empty String');
    }

    @isTest
    public static void setConditionPositiveAllConditionNullTest() {
        List<String> conditions = new List<String>{null ,null ,null};
        String result = DBSOQLProcessor.setCondition(conditions);
        System.assertEquals('', result, 'setCondition return not Empty String');
    }

    @isTest
    public static void setConditionPositiveOneEmptyConditionTest() {
        List<String> conditions = new List<String>{'condition1','','condition3'};
        String result = DBSOQLProcessor.setCondition(conditions);
        System.assertEquals('WHERE condition1 AND condition3', result, 'setCondition return wrong String');
    }

    @isTest
    public static void setConditionPositiveOneNullConditionTest() {
        List<String> conditions = new List<String>{'condition1', null, 'condition3'};
        String result = DBSOQLProcessor.setCondition(conditions);
        System.assertEquals('WHERE condition1 AND condition3', result, 'setCondition return wrong String');
    }

}
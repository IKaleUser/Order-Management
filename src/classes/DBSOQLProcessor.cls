public with sharing class DBSOQLProcessor {

    private static final String OPERATOR_EQUAL          = '=';
    private static final String OPERATOR_PERCENT        = '%';
    private static final String OPERATOR_LIKE           = 'LIKE';
    private static final String OPERATOR_AND            = 'AND';
    private static final String OPERATOR_WHERE          = 'WHERE';

    public static String getConditionEqual(String fieldName, String value) {
        return String.isNotBlank(value) ? fieldName + OPERATOR_EQUAL + '\'' + value + '\'' : '';
    }
    public static String getConditionLike(String fieldName, String value) {
        return String.isNotBlank(value) ? fieldName + ' ' + OPERATOR_LIKE + '\'' + OPERATOR_PERCENT + value.trim() + OPERATOR_PERCENT + '\'' : '';
    }

    public static String setCondition(List<String> conditions) {
        String conditionsString = '';

        for (String condition : conditions) {
            if (String.isNotBlank(condition)) {
                conditionsString += String.isBlank(conditionsString) ?
                                            OPERATOR_WHERE + ' ' + condition :
                                                            (' ' + OPERATOR_AND + ' ' + condition);
            }
        }
        return conditionsString;
    }

}
/**
 * Created by POTERFI on 2/10/2022.
 */

public with sharing class StringQueryBuilder {

    private String type = 'SELECT ';
    private Map<String, String> wherex = new Map<String, String>();
    private Set<String> fields = new Set<String>();
    private Map<String, String> operators = new Map<String, String>();
    private String fromKeyWord = ' FROM ';
    private String fromx;
    private String query;

    public StringQueryBuilder fromx(String fromx) {
        this.fromx = fromx;
        return this;
    }

    public StringQueryBuilder addFields(Set<String> fields) {
        this.fields = fields;
        return this;
    }

    public StringQueryBuilder addField(String field) {
        this.fields.add(field);
        return this;
    }

    public StringQueryBuilder addWhere(String name, String value, String operator) {

        if (value != null && String.isNotEmpty(value)) {
            this.wherex.put(name, '\'' + value + '\'');
            this.operators.put(name, operator);

        }
        return this;
    }

    public StringQueryBuilder addWhere(String name, Date value, String operator) {
        if (value != null) {
            this.wherex.put(name, String.valueOf(value).removeEnd(' 00:00:00'));
            this.operators.put(name, operator);
        }
        return this;
    }

    public String build() {

        String query = type;

        for (String field : fields) {
            query += field + ', ';
        }

        query = query.removeEnd(', ');
        query += fromKeyWord + fromx;

        if (wherex.size() > 0) {
            query += ' WHERE ';
        } else {
            query = query.removeEnd(' = ');
        }

        for (String name : wherex.keySet()) {
            query += name + ' ' + operators.get(name) + ' ' + wherex.get(name) + ' AND ';
        }

        query = query.removeEnd(' AND ');
        return query;
    }

    public List<SObject> query() {
        String queryToExecute = build();
        clearTables();
        return Database.query(queryToExecute);
    }

    public void clearTables() {
        wherex = new Map<String, String>();
        fields = new Set<String>();
        operators = new Map<String, String>();
        query = '';
    }


}
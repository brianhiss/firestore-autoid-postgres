# Firestore AutoId as a Postgres Function

For those that use a hybrid approach of Firestore and Google Cloud SQL (Postgres). 

Having a way to generate Firestore equivalent ids in Postgres without a `js` client-side hack like: `firestore().collection('tmp').doc().id`.

This is an exact SQL clone of the `firebase-js-sdk` [version](https://github.com/firebase/firebase-js-sdk/blob/4090271bb71023c3e6587d8bd8315ebf99b3ccd7/packages/firestore/src/util/misc.ts). 

## Install pgcrypto extension
```sql
CREATE extension IF NOT EXISTS pgcrypto;
```

## Create a new table
```sql
CREATE TABLE IF NOT EXISTS test_autoid (
  id VARCHAR NOT NULL PRIMARY KEY DEFAULT firestore_id()
);
```

## Modify an existing table and column default
```sql
ALTER TABLE test_autoid ALTER COLUMN id SET DEFAULT firestore_id();
```

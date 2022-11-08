try{
    print('Start #################################################################');

    db = db.getSiblingDB('authentication_service');
    db.createUser(
      {
        user: 'root',
        pwd: 'rootpassword',
        roles: [{ role: 'readWrite', db: 'authentication_service' }],
      },
    );
    db.createCollection('users');
    
    print('END #################################################################');
}catch(e){
    console.log(`MONGO INIT SCRIPT ERROR:: ${e}`);
}
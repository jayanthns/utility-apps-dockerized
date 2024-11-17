db.createUser(
    {
        user: "mongo-user",
        pwd: "password",
        roles: [
            {
                role: "readWrite",
                db: "<database to create>"
            }
        ]
    }
);

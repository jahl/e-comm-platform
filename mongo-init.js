db = db.getSiblingDB('e_comm_platform_development');
db.createUser({
  user: "dev_user",
  pwd: "3x4mpl3",
  roles: [{ role: "readWrite", db: "e_comm_platform_development" }]
});

db = db.getSiblingDB('e_comm_platform_test');
db.createUser({
  user: "test_user",
  pwd: "3x4mpl3",
  roles: [{ role: "readWrite", db: "e_comm_platform_test" }]
});
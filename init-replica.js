conn = new Mongo("mongodb://admin:adminpass@localhost:27017");
db = conn.getDB("admin");

try {
    let status = rs.status();
    print("ℹ️ Replica Set já configurado.");
} catch (err) {
    if (err.codeName === "NotYetInitialized") {
        print("🚀 Iniciando Replica Set...");
        rs.initiate({
            _id: "rs0",
            members: [
                { _id: 0, host: "mongo_primary:27017" },
                { _id: 1, host: "mongo_secondary_1:27017" },
                { _id: 2, host: "mongo_secondary_2:27017" }
            ]
        });
        print("✅ Replica Set inicializado com sucesso!");
    } else {
        print("❌ Erro ao verificar status do Replica Set:", err);
        throw err;
    }
}
#!/bin/bash

echo "Aguardando MongoDB iniciar..."
sleep 10

echo "Configurando Replica Set..."
mongosh --quiet --username admin --password adminpass --eval "
rs.initiate({
  _id: 'rs0',
  members: [
    { _id: 0, host: 'mongo_primary:27017' },
    { _id: 1, host: 'mongo_secondary_1:27017' },
    { _id: 2, host: 'mongo_secondary_2:27017' }
  ]
})
"

echo "✅ Replica Set configurado com sucesso!"
TARGET="http://localhost:3000"

echo "Initiating Linked VERSE telemetry generation..."

for i in {1..5}; do
  curl -s -X POST $TARGET/log -H "Content-Type: application/json" -d '{
    "level": "info", "service": "linked-verse-api", "player_id": "P00'$i'", "player_name": "Player'$i'", "event_type": "Gate Access Success", "linked_gate": "GATE_A", "status": "success", "message": "Gate accessed successfully."
  }'
  
  curl -s -X POST $TARGET/log -H "Content-Type: application/json" -d '{
    "level": "warn", "service": "linked-verse-api", "player_id": "P00'$i'", "player_name": "Player'$i'", "event_type": "Gate Unlock Failed", "linked_gate": "GATE_B", "status": "failed", "message": "Insufficient resources to unlock."
  }'
  
  curl -s -X POST $TARGET/log -H "Content-Type: application/json" -d '{
    "level": "info", "service": "linked-verse-api", "player_id": "P00'$i'", "player_name": "Player'$i'", "event_type": "Challenge Start", "linked_gate": "GATE_A", "status": "in_progress", "message": "Challenge initiated."
  }'
  
  curl -s -X POST $TARGET/log -H "Content-Type: application/json" -d '{
    "level": "info", "service": "linked-verse-api", "player_id": "P00'$i'", "player_name": "Player'$i'", "event_type": "Challenge Clear", "linked_gate": "GATE_A", "status": "success", "message": "Challenge cleared."
  }'
  
  curl -s -X POST $TARGET/log -H "Content-Type: application/json" -d '{
    "level": "error", "service": "linked-verse-api", "player_id": "P00'$i'", "player_name": "Player'$i'", "event_type": "Challenge Failed", "linked_gate": "GATE_C", "status": "failed", "message": "Player failed challenge."
  }'
done

echo "Injecting suspicious activity vectors..."

for i in {1..3}; do
  curl -s -X POST $TARGET/log -H "Content-Type: application/json" -H "X-Forwarded-For: 192.168.66.66" -d '{
    "level": "warn", "service": "linked-verse-api", "player_id": "UNKNOWN", "player_name": "UNKNOWN", "event_type": "Invalid Gate Request", "linked_gate": "GATE_NULL", "status": "rejected", "message": "Gate parameter invalid.", "source_ip": "192.168.66.66"
  }'
done

echo "Executing debug fault injections..."

curl -s -X POST $TARGET/debug/malformed-log

curl -s -X POST $TARGET/debug/missing-field-log

echo "Telemetry generation sequence terminated."

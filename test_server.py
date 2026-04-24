from mcstatus import JavaServer

server = JavaServer.lookup("localhost:8888")
status = server.status()

print("Server description:", status.description)
print("Players online:", status.players.online)
print("Max players:", status.players.max)

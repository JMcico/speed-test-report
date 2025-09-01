import speedtest

st = speedtest.Speedtest()
st.get_servers([])  # Get a list of all servers

servers = st.servers  # This is a dictionary of servers keyed by their country codes

# Find and print servers near your branch location
print("Searching for servers in the United Kingdom...")
for server_list in servers.values():
    for server in server_list:
        if server['country'].lower() == "united kingdom":
            print(f"ID: {server['id']}, Sponsor: {server['sponsor']}, Name: {server['name']}, Host: {server['host']}")

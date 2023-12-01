# Use the official OpenJDK image as the base image
FROM openjdk:latest

# Install dumb-init
RUN curl -o /usr/local/bin/dumb-init -L https://github.com/Yelp/dumb-init/releases/download/v1.2.5/dumb-init_1.2.5_amd64 && \
    chmod +x /usr/local/bin/dumb-init


# Set the working directory
WORKDIR /minecraft

# Expose the Minecraft server port
EXPOSE 25565

# Create a non-root user named 'minecraft'
RUN useradd -m -d /minecraft -s /bin/bash minecraft

# Download and install the necessary Java version
# Note: Adjust the URL accordingly for the latest version
RUN curl -o /minecraft/server.jar https://api.papermc.io/v2/projects/paper/versions/1.20.2/builds/309/downloads/paper-1.20.2-309.jar

# Create a volume for persistent storage of worlds
VOLUME ["/minecraft"]

# Copy the default server.properties file
RUN cat <<EOL > /minecraft/server.properties
#Minecraft server properties
#(File modification date and time)
enable-jmx-monitoring=false
rcon.port=25575
level-seed=
gamemode=survival
enable-command-block=false
enable-query=false
generator-settings={}
enforce-secure-profile=true
level-name=world
motd=A Minecraft Server
query.port=25565
pvp=true
generate-structures=true
max-chained-neighbor-updates=1000000
difficulty=easy
network-compression-threshold=256
max-tick-time=60000
require-resource-pack=false
use-native-transport=true
max-players=20
online-mode=true
enable-status=true
allow-flight=false
initial-disabled-packs=
broadcast-rcon-to-ops=true
view-distance=10
server-ip=
resource-pack-prompt=
allow-nether=true
server-port=25565
enable-rcon=false
sync-chunk-writes=true
op-permission-level=4
prevent-proxy-connections=false
hide-online-players=false
resource-pack=
entity-broadcast-range-percentage=100
simulation-distance=10
rcon.password=
player-idle-timeout=0
force-gamemode=false
rate-limit=0
hardcore=false
white-list=false
broadcast-console-to-ops=true
spawn-npcs=true
spawn-animals=true
log-ips=true
function-permission-level=2
initial-enabled-packs=vanilla
level-type=minecraft\:normal
text-filtering-config=
spawn-monsters=true
enforce-whitelist=false
spawn-protection=16
resource-pack-sha1=
max-world-size=29999984
EOL

# Create a Eula file
RUN cat <<EOL > /minecraft/eula.txt
eula=true
EOL

# Set ownership and permissions
RUN chown -R minecraft:minecraft /minecraft && \
    chmod -R 755 /minecraft

# Switch to the 'minecraft' user
USER minecraft


# CMD instruction to start the Minecraft server with dumb-init
CMD ["dumb-init", "java", "-Xms1G", "-Xmx1G", "-jar", "/minecraft/server.jar", "nogui"]
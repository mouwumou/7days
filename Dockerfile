###########################################################
# Dockerfile that builds a 7 days to die Gameserver
###########################################################
FROM cm2network/steamcmd:root as build_stage

ENV STEAMAPPID 294420
ENV STEAMAPP 7DaysToDieServer
ENV STEAMAPPDIR "${HOMEDIR}/7DaysToDieServer"
ENV DLURL https://raw.githubusercontent.com/mouwumou/7days

RUN set -x \
	# Install, update & upgrade packages
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
        wget=1.21-1+deb11u1 \
        ca-certificates=20210119 \
        lib32z1=1:1.2.11.dfsg-2+deb11u2 \
	&& mkdir -p "${STEAMAPPDIR}" \
	# Add entry script
	&& wget --max-redirect=30 "${DLURL}/main/entry.sh" -O "${HOMEDIR}/entry.sh" \
	&& { \
		echo '@ShutdownOnFailedCommand 1'; \
		echo '@NoPromptForPassword 1'; \
		echo 'force_install_dir '"${STEAMAPPDIR}"''; \
		echo 'login anonymous'; \
		echo 'app_update '"${STEAMAPPID}"''; \
		echo 'quit'; \
	   } > "${HOMEDIR}/${STEAMAPP}_update.txt" \
	&& chmod +x "${HOMEDIR}/entry.sh" \
	&& chown -R "${USER}:${USER}" "${HOMEDIR}/entry.sh" "${STEAMAPPDIR}" "${HOMEDIR}/${STEAMAPP}_update.txt" \
	# Clean up
	&& rm -rf /var/lib/apt/lists/* 

VOLUME ${STEAMAPPDIR}

FROM build_stage AS bullseye-base

# Switch to user
USER ${USER}

WORKDIR ${HOMEDIR}

CMD ["bash", "entry.sh"]

# Expose ports
EXPOSE 8080/tcp \
    8081/tcp \
    8082/tcp \
    26900/udp \
    26902/udp

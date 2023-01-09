#!/bin/bash
mkdir -p "${STEAMAPPDIR}" || true  

bash "${STEAMCMDDIR}/steamcmd.sh" +force_install_dir "${STEAMAPPDIR}" \
                +login anonymous \
                +app_update "${STEAMAPPID}" \
                +quit

cd "${STEAMAPPDIR}"

bash ./startserver.sh -configfile=serverconfig.xml
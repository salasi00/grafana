FROM grafana/grafana:latest

ENV GF_USERS_DEFAULT_THEME=light
ENV GF_FEATURE_TOGGLES_ENABLE=topnav

# Home Dashboard
# ENV GF_DASHBOARDS_DEFAULT_HOME_DASHBOARD_PATH=/etc/grafana/provisioning/dashboards/supervisor.json

# Paths
# ENV GF_PATHS_PROVISIONING="/etc/grafana/provisioning"
# ENV GF_PATHS_PLUGINS="/var/lib/grafana/plugins"

# Copy artifacts
# COPY --chown=grafana:root dist /app
# COPY entrypoint.sh /

# Provisioning
# COPY --chown=grafana:root provisioning $GF_PATHS_PROVISIONING

###### Customization ########################################
USER root

# Replace Favicon
COPY ./grafana/img/ /usr/share/grafana/public/img/

COPY ./grafana/plugins/welcome/ /usr/share/grafana/public/app/plugins/panel/welcome/

COPY ./grafana/build/5017.830b14490d17e9cbdabb.js /usr/share/grafana/public/build/5017.830b14490d17e9cbdabb.js

# Replace Logo
# COPY img/logo.svg /usr/share/grafana/public/img/grafana_icon.svg

# Background
# COPY img/background.svg /usr/share/grafana/public/img/g8_login_dark.svg
# COPY img/background.svg /usr/share/grafana/public/img/g8_login_light.svg

# Update Javascript
RUN find /usr/share/grafana/public/build/ -type f -name '*.js' -exec sed -i 's|,i\.AppTitle="Grafana",|,i\.AppTitle="vDSP Provisioning",|g' {} +
RUN find /usr/share/grafana/public/ -type f -exec sed -i 's|Welcome to Grafana|Welcome to vDSP Provisioning|g' {} +
RUN find /usr/share/grafana/public/app/core/components/ -type f -exec sed -i "s|AppTitle = 'Grafana'|AppTitle = 'vDSP Provisioning'|g" {} +
RUN find /usr/share/grafana/public/build/ -name *.js -exec sed -i 's|\[{target:"_blank",id:"documentation".*grafana_footer"}\]|\[\]|g' {} \;
## Remove Edition in the Footer
RUN find /usr/share/grafana/public/build/ -name *.js -exec sed -i 's|({target:"_blank",id:"license",.*licenseUrl})|()|g' {} \;

## Remove Version in the Footer
RUN find /usr/share/grafana/public/build/ -name *.js -exec sed -i 's|({target:"_blank",id:"version",.*CHANGELOG.md":void 0})|()|g' {} \;

## Remove News icon
RUN find /usr/share/grafana/public/build/ -name *.js -exec sed -i 's|..createElement(....,{className:.,onClick:.,iconOnly:!0,icon:"rss","aria-label":"News"})|null|g' {} \;

## Remove Open Source icon
RUN find /usr/share/grafana/public/build/ -name *.js -exec sed -i 's|.push({target:"_blank",id:"version",text:`${..edition}${.}`,url:..licenseUrl,icon:"external-link-alt"})||g' {} \;

#############################################################

# USER grafana

# Entrypoint
# ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]

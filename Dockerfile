FROM google/cloud-sdk:224.0.0-alpine AS build

RUN apk add --update py-setuptools py-pip \
    && rm -rf /var/cache/apk/* \
    && pip install wheel

WORKDIR /opt/python-gitlab
COPY . .
RUN python setup.py bdist_wheel

FROM google/cloud-sdk:224.0.0-alpine

RUN apk add --update py-setuptools py-pip \
    && rm -rf /var/cache/apk/*

WORKDIR /opt/python-gitlab
COPY --from=build /opt/python-gitlab/dist dist/
RUN pip install $(find dist -name *.whl) && \
    rm -rf dist/
COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["--version"]

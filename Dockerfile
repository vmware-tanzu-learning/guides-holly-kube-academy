FROM sphinxdoc/sphinx:5.3.0
RUN apt-get update && apt-get install -y git && apt-get clean
COPY . /usr/src/lab
COPY Makefile-sphinx /usr/src/lab/Makefile
WORKDIR /usr/src/lab
RUN pip install --no-cache-dir sphinx-book-theme==v1.0.1 sphinx-copybutton==v0.5.2 sphinx_design==v0.5.0 git+https://github.com/bonartm/sphinxcontrib-quizdown
ARG VERSION
ENV DOCS_VERSION=$VERSION
ENV SPHINX_TAG="strigo"
RUN make html
ENV SPHINX_TAG="educates"
RUN make html BUILDDIR="educates"

FROM nginxinc/nginx-unprivileged:1.19-alpine
ARG   IMAGE_SOURCE
ARG VERSION
LABEL org.opencontainers.image.source $IMAGE_SOURCE
# WORKDIR creates directories as a side-effect
WORKDIR /usr/share/nginx/html
COPY --from=0 /usr/src/lab/build/html /usr/share/nginx/html
COPY --from=0 /usr/src/lab/educates/html /usr/share/nginx/html/educates

USER 1000
COPY --from=0 --chown=1000:1000 /usr/src/lab/workshop-resources /tmp/workshop-resources
COPY --from=0 --chown=1000:1000 /usr/src/lab/workshop-resources /educates-resources
WORKDIR /tmp/workshop-resources/apply
ENV VERSION=${VERSION}
RUN for f in *.yaml; do envsubst '${VERSION}' < $f > /educates-resources/apply/$f; done
RUN rm -rf /tmp/workshop-resources
WORKDIR /educates-resources
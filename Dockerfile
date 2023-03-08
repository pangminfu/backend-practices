ARG GO_VERSION=1.20

###########
# MODULES #
###########

# FROM --platform=${BUILDPLATFORM} golang:${GO_VERSION} AS modules

# WORKDIR /src

# COPY ./go.mod ./go.sum ./

# ######## START PRIVATE MODULES with github deploy keys

# ## reference: https://docs.docker.com/develop/develop-images/build_enhancements/#using-ssh-to-access-private-data-in-builds
# ## / ! \ you have to create a new deploy key for each repository
# ## for golang-common, create a new key as well, check other existing keys for naming convention

# # Download public key for github.com
# RUN mkdir -p -m 0700 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

# # The solution from https://stackoverflow.com/questions/64462922/docker-multi-stage-build-go-image-x509-certificate-signed-by-unknown-authorit
# # install storage.googleapis.com certs
# RUN apt-get update && apt-get install -y ca-certificates openssl

# # Get certificate from "storage.googleapis.com"
# RUN openssl s_client -showcerts -connect storage.googleapis.com:443 </dev/null 2>/dev/null| openssl x509 -outform PEM >  \
#     /usr/local/share/ca-certificates/googleapis.crt

# # Update certificates
# RUN update-ca-certificates


# # Forces the usage of git and ssh key fwded by ssh-agent for xxxxxxx git repos
# RUN git config --global url."git@github.com:xxxxxxx/".insteadOf "https://github.com/xxxxxxx/"

# ######## END PRIVATE MODULES with github deploy keys

# # private go packages
# ENV GOPRIVATE=github.com/xxxxxxx/*

# RUN --mount=type=ssh go mod download


###########
# BUILDER #
###########

FROM --platform=${BUILDPLATFORM} golang:${GO_VERSION} AS builder

# COPY --from=modules /go/pkg /go/pkg

RUN useradd -u 10001 nonroot

WORKDIR /src

COPY ./ ./

ARG BINARY_NAME 
ARG GLOBAL_VAR_PKG

ARG TARGETOS
ARG TARGETARCH

ARG LAST_MAIN_COMMIT_HASH
ARG LAST_MAIN_COMMIT_TIME

ENV FLAG="-X ${GLOBAL_VAR_PKG}.CommitTime=${LAST_MAIN_COMMIT_TIME}"
ENV FLAG="$FLAG -X ${GLOBAL_VAR_PKG}.CommitHash=${LAST_MAIN_COMMIT_HASH}"

RUN CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH go build \
    -installsuffix 'static' \
    -ldflags "-s -w $FLAG" \
    -buildvcs=true \
    -o /app ./cmd/${BINARY_NAME}/*.go


##############
# COMPRESSOR #
##############

# comment this part due to some unknown issue cause by upx on aws graviton

# FROM --platform=${BUILDPLATFORM} golang:${GO_VERSION} AS compressor

# RUN apt-get update && \
#     apt-get install -y upx --no-install-recommends && \
#     rm -rf /var/lib/apt/lists/*

# COPY --from=builder /app /app

# RUN /usr/bin/upx /app --best --lzma


#########
# FINAL #
#########

FROM scratch AS final

COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

ARG BINARY_NAME 

COPY ./config/${BINARY_NAME} /config/${BINARY_NAME}

COPY --from=builder /app /app

USER nonroot

CMD ["/app"]

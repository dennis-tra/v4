FROM node:10 as builder

LABEL maintainer="Dennis Trautwein"

# Create non root user + group
# groupadd:
#   -r create a system group
#   -g group id (values between 0 and 999 are typically reserved for system accounts)
# useradd:
#   -l do not add the user to the lastlog and faillog databases.
#   -r create a system user
#   -m create home directory for user
#   -u user id (values between 0 and 999 are typically reserved for system accounts)
#   -g the group the user belongs to
RUN groupadd -r -g 999 builder && \
    useradd -l -r -m -u 999 -g builder builder

# become the just created user
USER builder

# Setup working directory
RUN mkdir /home/builder/site
WORKDIR /home/builder/site

# Install dependencies
COPY package.json yarn.lock ./
RUN yarn

# Copy project files
COPY . .

# Build website
RUN yarn run build

# Package built website in an alpine container for smaller image size
FROM alpine:3.10.2
COPY --from=builder /home/builder/site/public /public
FROM rust:slim as builder

# create a new empty shell project
RUN USER=root cargo new --bin app
WORKDIR /app

# copy over your manifests
COPY ./Cargo.lock ./Cargo.lock
COPY ./Cargo.toml ./Cargo.toml

# this build step will cache your dependencies
RUN cargo build --release
RUN rm src/*.rs

# copy your source tree
COPY ./src ./src

# build for release
RUN rm ./target/release/deps/rust_api_thing*
RUN cargo build --release

# our final base
FROM rust:slim

# copy the build artifact from the build stage
COPY --from=builder /app/target/release/rust-api-thing .

# set the startup command to run your binary
CMD ["./rust-api-thing"]

# API Endpoints

## Home

- `GET /homes`
  - Used by: `HomeRemoteDataSource.getHome()`
  - Maps to: `HomeResponse` and `HomeModel`

## Notes

- Endpoint constants are maintained in `lib/core/constants/api_urls.dart`.
- Shared request handling is done by `lib/core/network/api_client.dart`.

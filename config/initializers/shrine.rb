require "cloudinary"
require "shrine/storage/cloudinary"
Cloudinary.config(
cloud_name: "ds6lecehm",
api_key:    "833675591977979",
api_secret: "0GCxJeY1ze0_QmvKqokE50brM9I",
)
Shrine.storages = {
cache: Shrine::Storage::Cloudinary.new(prefix: "cache"), # for direct uploads
store: Shrine::Storage::Cloudinary.new(prefix: "rails_uploads"),
}
Shrine.plugin :activerecord           # loads Active Record integration
Shrine.plugin :cached_attachment_data # enables retaining cached file across form redisplays
Shrine.plugin :restore_cached_data    # extracts metadata for assigned cached files
Shrine.plugin :validation_helpers
Shrine.plugin :validation
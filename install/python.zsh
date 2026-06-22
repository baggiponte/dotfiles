# +---------------------+
# | install python CLIs |
# +---------------------+

versions=(
	"3.13"
	"3.12"
	"3.11"
	"3.10"
)

for version in "${versions[@]}"; do
	uv python install -- "$version" || true
done

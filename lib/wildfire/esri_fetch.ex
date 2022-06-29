defmodule Wildfire.ESRIFetch do
  def fetch_and_process do
    # Get the incident data and convert it into a map using the IncidentName as the key
    incident_url =
      "https://services9.arcgis.com/RHVPKKiFTONKtxq3/ArcGIS/rest/services/USA_Wildfires_v1/FeatureServer/0/query?where=1%3D1&outFields=OBJECTID%2C+IncidentName%2C+FireDiscoveryDateTime%2C+UniqueFireIdentifier&outSR=4326&resultRecordCount=20&f=geojson"

    incident_data = fetch_data_from_url(incident_url)

    incidents = process_features(incident_data, &process_incident_feature/1)

    # Get the perimeter data and convert it into a map using the IncidentName as the key
    perimeter_url =
      "https://services9.arcgis.com/RHVPKKiFTONKtxq3/ArcGIS/rest/services/USA_Wildfires_v1/FeatureServer/1/query?where=1%3D1&outFields=OBJECTID%2C+IncidentName&outSR=4326&resultRecordCount=20&f=geojson"

    perimeter_data = fetch_data_from_url(perimeter_url)

    perimeters = process_features(perimeter_data, &process_perimeter_feature/1)

    # Get the incident names from the incident map, filter the perimeter map to the incidents we have, then combine them together
    incidentNames = Map.keys(incidents)

    perimeters_and_incidents =
      perimeters
      |> Map.filter(fn {key, _value} -> Enum.member?(incidentNames, key) end)
      |> Map.merge(incidents, fn (_key, perimeter, incident) -> Map.merge(perimeter, incident) end)

    # Send the combined incident and perimeter map back to the channel
    WildfireWeb.Endpoint.broadcast("esri:public", "new_data", perimeters_and_incidents)
  end

  def process_features(%{"features" => features}, processing_function) do
    features
    |> Enum.map(processing_function)
    |> Enum.reduce(%{}, fn (incident, map) -> Map.put(map, incident["IncidentName"], incident) end)
  end

  def process_features(_data, _function), do: %{}

  def process_individual_feature(%{"geometry" => %{"coordinates" => coordinates}, "id" => id, "properties" => properties}, identifier) do
    properties
    |> Map.delete("OBJECTID")
    |> Map.put("#{identifier}Id", id)
    |> Map.put("#{identifier}Coordinates", coordinates)
  end

  def process_incident_feature(feature) do
    process_individual_feature(feature, "Incident")
  end

  def process_perimeter_feature(feature) do
    process_individual_feature(feature, "Perimeter")
  end

  def fetch_data_from_url(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200} = response} ->
        Jason.decode!(response.body)

      _ ->
        # We could do some kind of error handling here, but for now we'll just ignore and wait for the next fetch
        %{}
    end
  end
end
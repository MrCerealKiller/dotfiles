get_notion_top_three() {
  curl --silent \
    --request POST \
    --url https://api.notion.com/v1/data_sources/1fa6ba7c-302f-8105-8c37-000b33da35fb/query\?filter_properties\=title \
    --header "Authorization: Bearer $( secret-tool lookup domain notion.so )" \
    --header 'Content-Type: application/json' \
    --header 'Notion-Version: 2026-03-11' \
    --data '
  {
    "sorts": [
      {
        "property": "Due",
        "direction": "descending"
      }
    ],
    "filter": {
      "and": [
        {
          "property": "Status",
          "status": {
            "equals": "To-Do"
          }
        },
        {
          "property": "Assignee",
          "people": {
            "contains": "1fad872b-594c-81db-ad21-00027d84be54"
          }
        }
      ]
    },
    "page_size": 3,
    "in_trash": false,
    "result_type": "page"
  }
  ' | jq -r '.results[] | .properties["Task name"].title[0].plain_text'
}

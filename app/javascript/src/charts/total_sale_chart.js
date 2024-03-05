let colorPalette = [
  '#3A5A40',
  '#A3B18A',
  '#ECF39E',
  '#CFE1B9',
]

export function totalSaleChartOption(data) {
  let totalAmount = data.reduce((acc, item) => acc + item.amount, 0)

  return {
    title: {
      top: -5,
      left: 'center',
      text: 'ภาพรวมยอดขาย',
      subtext: [`ยอดขายทั้งหมด`,`{amount|${totalAmount.toLocaleString()}}`,`บาท`].join(" "),
      textStyle: {
        fontFamily: 'Kanit'
      },
      subtextStyle: {
        fontFamily: 'Kanit',
        fontSize: 14,
        color: "#718355",
        rich: {
          "amount": {fontSize: 16, fontWeight: 700, verticalAlign: 'bottom'}
        }
      }
    },
    dataset: { source: data },
    series: [
      {
        type: 'pie',
        top: 25,
        color: colorPalette,
        label: { 
          show: true,
          width: 385,
          formatter: (params) => {
            return [
              `{product| ${params.data.product}}`,
              `{amount| ${parseInt(params.data.amount).toLocaleString()}} บาท`,
              ].join("\n")
          },
          rich: {
            "product": { fontFamily: 'Kanit', fontSize: 14 },
            "amount": { fontFamily: 'Kanit', fontSize: 19, padding: [6,0,0,0] }
          }
        }
      },
      {
        type: 'pie',
        top: 25,
        label: {
          show: true,
          position: 'inside',
          formatter: (params) => {
            let percent = ((parseInt(params.data.amount) / totalAmount) * 100.0).toFixed(2)
            if(Number(percent) > 5.0) {
              switch(params.color) {
                case "#ECF39E": return `{percentDark| ${percent}%}`
                case "#3A5A40": return `{percentLight| ${percent}%}`
                case "#A3B18A": return `{percentShine| ${percent}%}`
                default: return `{percentNormal| ${percent}%}`
              }
            } else {
              return `{percentSmall| ${percent}%}`
            }
          },
          rich: {
            "percentDark": { fontFamily: 'Kanit', fontSize: 19, forWeight: 'bold', color: '#3A5A40' },
            "percentLight": { fontFamily: 'Kanit', fontSize: 19, forWeight: 'bold', color: '#B5C99A' },
            "percentShine": { fontFamily: 'Kanit', fontSize: 19, forWeight: 'bold', color: '#ECF39E' },
            "percentSmall": { fontFamily: 'Kanit', fontSize: 14, forWeight: 'bold', color: '#0a0a0a' },
          }
        }
      }
    ]
  }
}

export function initTotalSaleChart(chartId) {
  let container = document.getElementById(chartId)
  if(container == null) { return }

  let chart = window.echarts.init(container);
  chart.on("click", function(params){
    console.log(params)
    let url = `${container.dataset.appUrl}/products/${params.data.product_slug}`
    window.location.href = url
  })

  return chart
}

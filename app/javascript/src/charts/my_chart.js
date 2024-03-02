let colorPalette = [
  '#3A5A40',
  '#A3B18A',
  '#ECF39E',
  '#CFE1B9',
]

export function myChartOption(data) {
  let totalAmount = data.reduce((acc, item) => acc + item.amount, 0)

  return {
    title: {
      top: -5,
      left: 'center',
      text: 'ภาพรวมยอดขาย',
      subtext: [`ยอดขายทั้งหมด`,`{amount|${totalAmount}}`,`บาท`].join(" "),
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
              return `{percentNormal| ${percent}%}`
            } else {
              return `{percentSmall| ${percent}%}`
            }
          },
          rich: {
            "percentNormal": { fontFamily: 'Kanit', fontSize: 19, forWeight: 'bold', color: '#fefefe' },
            "percentSmall": { fontFamily: 'Kanit', fontSize: 14, forWeight: 'bold', color: '#0a0a0a' },
          }
        }
      }
    ]
  }
}

export function initMyChart(chartId) {
  let myChart = document.getElementById(chartId)
  if(myChart == null) { return }

  let pie = window.echarts.init(myChart);
  return pie
}

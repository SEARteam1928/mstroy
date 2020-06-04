<style lang="sass">
.my-sticky-header-column-table
  /* specifying max-width so the example can
    highlight the sticky column on any browser window */
  max-width: 600px

  /* max height is important */
  .q-table__middle
    max-height: 200px

  td:first-child
    /* bg color is important for td; just specify one */
    background-color: #c1f4cd !important

  tr th
    position: sticky
    /* higher than z-index for td below */
    z-index: 2
    /* bg color is important; just specify one */
    background: #fff

  tr:first-child th
    top: 0
  tr:first-child th:first-child
    /* highest z-index */
    z-index: 3

  td:first-child
    z-index: 1

  td:first-child, th:first-child
    position: sticky
    left: 0

  /* this is when the loading indicator appears */
  &.q-table--loading thead tr:last-child th
    /* height of all previous header rows */
    top: 48px
    /* highest z-index */
    z-index: 3
</style>
<template>
  <section>
    <template>
    <q-card style="height:250px;width:600px; margin-left:15px;">
      <q-card-section class="q-pa-none echarts" style="height:250px;width:600px">
        <IEcharts :option="option" :resizable="true" :loading="loading" />
      </q-card-section>
    </q-card>
    </template>
    <template>
    <div class="q-pa-md">
    <q-table
      class="my-sticky-header-column-table"
      title="Трудозатраты по источникам"
      :data="data"
      :columns="columns"
      row-key="name"
    />
    </div>
  </template>
  <template>
  <div class="q-pa-md">
    <q-table
      title="Эффективность работы"
      :data="data"
      :columns="columns1"
      row-key="name"
    >
      <template v-slot:body="props">
        <q-tr :props="props">
          <q-td key="name" :props="props">
            {{ props.row.name }}
          </q-td>
          <q-td key="calories" :props="props">
            <q-badge color="green">
              {{ props.row.calories }}
            </q-badge>
          </q-td>
          <q-td key="fat" :props="props">
            <q-badge color="purple">
              {{ props.row.fat }}
            </q-badge>
          </q-td>
          <q-td key="carbs" :props="props">
            <q-badge color="orange">
              {{ props.row.carbs }}
            </q-badge>
          </q-td>
          <q-td key="protein" :props="props">
            <q-badge color="primary">
              {{ props.row.protein }}
            </q-badge>
          </q-td>
          <q-td key="sodium" :props="props">
            <q-badge color="teal">
              {{ props.row.sodium }}
            </q-badge>
          </q-td>
          <q-td key="calcium" :props="props">
            <q-badge color="accent">
              {{ props.row.calcium }}
            </q-badge>
          </q-td>
          <q-td key="iron" :props="props">
            <q-badge color="amber">
              {{ props.row.iron }}
            </q-badge>
          </q-td>
        </q-tr>
      </template>
    </q-table>
  </div>
</template>
  </section>
</template>
<script>
import IEcharts from 'vue-echarts-v3/src/full.js'
export default {
  name: 'charts',
  components: {
    IEcharts
  },
  data () {
    return {
      columns: [
        {
          name: 'date',
          required: true,
          label: 'Дата',
          align: 'left',
          field: row => row.name,
          format: val => `${val}`,
          loading: true,
          sortable: true
        },
        {
          name: 'spider',
          align: 'center',
          label: 'Спайдер',
          field: row => row.name,
          sortable: true
        },
        { name: 'tabel', label: 'Табель', field: row => row.name, sortable: true },
        { name: 'dev', label: 'Устройства', field: row => row.name, sortable: true },
      ],
      data: [],
      columns1: [
        {
          name: 'name',
          required: true,
          label: 'Дата',
          align: 'center',
          field: row => row.name,
          format: val => `${val}`,
          sortable: true
        },
        { name: 'calories', align: 'center', label: 'Трудозатраты (производ.)', field: 'calories', sortable: true },
        { name: 'fat', label: 'Трудозатраты (не производ.)', field: 'fat', sortable: true },
        { name: 'carbs', label: 'Заработная плата (производ.)', field: 'carbs' },
        { name: 'protein', label: 'Заработная плата (не производ.)', field: 'protein' },
        { name: 'sodium', label: 'Трудозатраты', field: 'sodium' },
        { name: 'calcium', label: 'Заработная плата', field: 'calcium', sortable: true },
        { name: 'iron', label: 'Эффективность', field: 'iron', sortable: true }
      ],
      option: {
        title: {
          text: ''
        },
        legend: {
          type: 'scroll',
          icon: 'roundRect',
          data: [0]
        },
        grid: {
          left: '3%',
          right: '4%',
          bottom: '3%',
          containLabel: true
        },
        xAxis: [
          {
            type: 'category',
            boundaryGap: false,
            data: []
          }
        ],
        yAxis: [
          {
            type: 'value'
          }
        ],
        series: [],
        toolbox: {
          show: true,
          showTitle: true,
          feature: {
            saveAsImage: {
              show: true,
              title: 'Сохранить'
            }
          }
        },
        tooltip: { // same as option.tooltip
          trigger: 'axis',
          axisPointer: {
            type: 'cross',
            label: {
              backgroundColor: '#6a7985'
            }
          }
        }
      }
    }
  }
}
</script>

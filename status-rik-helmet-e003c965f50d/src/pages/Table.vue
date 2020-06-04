<style lang="sass">
.my-sticky-header-column-table
  /* specifying max-width so the example can
    highlight the sticky column on any browser window */
  max-width: 1600px

  /* max height is important */
  .q-table__middle
    max-height: 680px

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
  <q-pull-to-refresh @refresh="refresh">
  <template>
    <div class="q-pa-md">
      <div class="row q-col-gutter-none">
      <q-btn-dropdown label="Каска" style="height:35px; margin-top:-10px;background:#e0e0e0;">
      <q-list v-for="fio in fio" :key="fio.id">
         <q-item  clickable v-close-popup @click="changtrack(fio.assets_number, date1, date2)">
          <q-item-section>
            <q-item-label>{{fio.assets_number}}</q-item-label>
          </q-item-section>
        </q-item>
      </q-list>
    </q-btn-dropdown>
      <template>
  <div class="q-pa-md" style="max-width: 170px;margin-top:-25px">
    <q-input filled v-model="date1" mask="date" :rules="['date1']">
      <template v-slot:append>
        <q-icon name="event" class="cursor-pointer">
          <q-popup-proxy ref="qDateProxy" transition-show="scale" transition-hide="scale">
            <q-date v-model="date1" @input="() => $refs.qDateProxy.hide()" />
          </q-popup-proxy>
        </q-icon>
      </template>
    </q-input>
  </div>
</template>
<template>
  <div class="q-pa-md" style="max-width: 170px;margin-top:-25px">
    <q-input filled v-model="date2" mask="date" :rules="['date2']">
      <template v-slot:append>
        <q-icon name="event" class="cursor-pointer">
          <q-popup-proxy ref="qDateProxy1" transition-show="scale" transition-hide="scale">
            <q-date v-model="date2" @input="() => $refs.qDateProxy1.hide()" />
          </q-popup-proxy>
        </q-icon>
      </template>
    </q-input>
  </div>
  <q-btn label="Выполнить" @click="goto(date1, date2)" style="height:35px; margin-top:-10px;background:#e0e0e0; "/>
</template>
    </div>
    <q-table
      class="Perf no-shadow"
      title="Treats"
      :data="posts"
      :columns="columns"
      row-key="name"
      :visible-columns="visibleColumns"
      style="border-radius: 0 0 4px 4px;border: 1px solid rgba(0,0,0,0.12);border-top-width: 1;"
    >
      <template v-slot:top="props">
        <q-input borderless dense debounce="300" v-model="filter" placeholder="  Поиск" style="background:#e0e0e0;">
          <template v-slot:append>
            <q-icon name="search" />
          </template>
        </q-input>
        <q-space />
        <q-select
          v-model="visibleColumns"
          multiple
          borderless
          dense
          options-dense
          :display-value="$q.lang.table.columns"
          emit-value
          map-options
          :options="columns"
          option-value="name"
          style="min-width: 150px"
        />
      </template>
      </q-table>
      </div>
</template>
</q-pull-to-refresh>
</section>
</template>
<script>
import { date } from 'quasar'
import { axiosInstance } from 'boot/axios'
let date1 = '2019/12/11'
let date2 = '2019/12/12'
export default {
  name: 'PageIndex',
  data () {
    return {
      visibleColumns: ['helmet_name', 'latitude', 'longitude', 'Pressure', 'ActivityLevel', 'Activity', 'Temperature', 'created_at', 'Battery', 'created_time', 'last_name'],
      posts: [],
      fio: [],
      filter: '',
      loading: true,
      date2,
      date1,
      columns: [
        {
          name: 'desc',
          required: true,
          label: ' ',
          align: 'left',
          field: row => row.assets_number,
          format: val => `${val}`,
          sortable: true,
          sort: (a, b) => parseInt(a) - parseInt(b)
        },
        { name: 'helmet_name', align: 'center', label: 'helmet_name', field: row => row.helmet_name, sortable: true },
        { name: 'latitude', align: 'center', label: 'latitude', field: row => row.latitude, sortable: true },
        { name: 'longitude', align: 'center', label: 'longitude', field: row => row.longitude, sortable: true },
        { name: 'Pressure', align: 'center', label: 'Pressure', field: row => row.Pressure, sortable: true },
        { name: 'ActivityLevel', align: 'center', label: 'ActivityLevel', field: row => row.ActivityLevel, sortable: true },
        { name: 'Activity', align: 'center', label: 'Activity', field: row => row.Activity, sortable: true },
        { name: 'Temperature', align: 'center', label: 'Temperature', field: row => row.Temperature, sortable: true },
        { name: 'created_at', align: 'center', label: 'created_at', field: row => row.created_at, sortable: true },
        { name: 'Battery', align: 'center', label: 'Battery', field: row => row.Battery, sortable: true },
        { name: 'created_time', align: 'center', label: 'created_time', field: row => row.created_time, sortable: true },
        { name: 'last_name', align: 'center', label: 'ФИО', field: row => row.last_name + ' ' + row.first_name + ' ' + row.surname, sortable: true }
      ]
    }
  },
  created () {
    axiosInstance.get('/helmets/workers_and_helmets').then(response => {
      this.fio = response.data
    })
    axiosInstance.get('/helmets/helmet_data_in_range',
      { params: {
        from_date: date.formatDate(date1, 'DD/MM/YYYY'),
        to_date: date.formatDate(date2, 'DD/MM/YYYY')
      }
      }).then(response => {
      this.posts = response.data
    })
  },
  methods: {
    changtrack (id, date1, date2) {
      axiosInstance.get('/helmets/workers_and_helmets').then(response => {
        this.fio = response.data
      })
      axiosInstance.get('/helmets/helmet_data_in_range/' + id,
        { params: {
          from_date: date.formatDate(date1, 'DD/MM/YYYY'),
          to_date: date.formatDate(date2, 'DD/MM/YYYY'),
        }
        }).then(response => {
        this.posts = response.data
      })
    },
    goto (date1, date2) {
      axiosInstance.get('/helmets/workers_and_helmets').then(response => {
        this.fio = response.data
      })
      axiosInstance.get('/helmets/helmet_data_in_range',
        { params: {
          from_date: date.formatDate(date1, 'DD/MM/YYYY'),
          to_date: date.formatDate(date2, 'DD/MM/YYYY')
        }
        }).then(response => {
        this.posts = response.data
      })
    },
    refresh (done) {
      setTimeout(function tick () {
        axiosInstance.get('/helmets/workers_and_helmets').then(response => {
          this.fio = response.data
        })
        axiosInstance.get('/helmets/helmet_data_in_range',
          { params: {
            from_date: date.formatDate(date1, 'DD/MM/YYYY'),
            to_date: date.formatDate(date2, 'DD/MM/YYYY')
          }
          }).then(response => {
          this.posts = response.data
        })
        location.reload()
        done()
      }, 500)
    }
  }
}
</script>
